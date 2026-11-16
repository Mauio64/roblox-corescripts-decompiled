local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appRunService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppRunService
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers")
local logger = Loggers.Logger
local mutedError = Loggers.mutedError

local module2 = require("@luauforge/bundled/edm")
local module3 = require("@luauforge/bundled/gdD")

local setUserHasRobloxSubscription = require("@luauforge/bundled/cgr").Actions.SetUserHasRobloxSubscription
local getLocalUser = require("@luauforge/bundled/cgr").Thunks.GetLocalUser
local sessionType = require("@luauforge/bundled/foF").SessionType
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dxT").GetCountryCodeStore else nil

local defineFastFlag = game:DefineFastFlag("FixWrongLoggedOutSessionSwitch", false)
local defineFastFlag2 = game:DefineFastFlag("TestAndroidWrongLoggedInIssue", false)
local module6 = require("@luauforge/bundled/hWI")

local module7 = require("@luauforge/bundled/hWE")

local function getCountryCode(value)
	return string.len(value) > 0 and value or "Unknown"
end

local extended = Roact.Component:extend("LocalPlayerManager")
extended.defaultProps = {
	backtraceReporter = nil,
	getLocalPlayerUserId = function()
		local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if userId == nil or userId <= 0 then
			return nil
		end

		return (tostring(userId))
	end,
	getCachedUserId = function()
		local userId = Models.fromLocalStorage().userId

		if userId > 0 then
			return (tostring(userId))
		end

		return nil
	end
}

function extended:init()
	self:setState({
		hasLocalPlayer = Players.LocalPlayer ~= nil,
		localPlayerUserId = self.props.getLocalPlayerUserId()
	})

	self.backtraceReporter = self.props.backtraceReporter or module7

	function self.fetchAndUpdateLocalPlayer()
		self.props.fetchLocalUserData()
		self.updateUserInfoToBacktrace()
		self.updateLocalPlayerState()
	end

	function self.updateLocalPlayerState()
		local localPlayerUserId = self.props.getLocalPlayerUserId()

		if defineFastFlag2 then
			print("[FLog::SessionService] currentLocalPlayerId " .. tostring(localPlayerUserId))
		end

		if localPlayerUserId ~= self.state.localPlayerUserId then
			self:setState({
				localPlayerUserId = localPlayerUserId or Roact.None,
				hasLocalPlayer = Players.LocalPlayer ~= nil
			})
		end
	end

	function self.updateUserInfoToBacktrace()
		local localPlayer = Players.LocalPlayer

		local v5 = (localPlayer == nil or localPlayer.UserId <= 0)
			and {
				UserLoggedIn = false,
				UserMembershipType = "Unknown",
				UserIsUnder13 = "Unknown",
				CountryCode = "Unknown"
			}
			or {
				UserLoggedIn = true,
				UserMembershipType = tostring(localPlayer.MembershipType),
				UserIsUnder13 = localPlayer:GetUnder13(),
				CountryCode = self.props.countryCode
			}

		self.backtraceReporter:updateSharedAttributes(v5)
	end

	function self.syncUserSession(p2)
		if defineFastFlag2 then
			print("[FLog::SessionService] syncUserSession()")

			if p2 then
				print("[FLog::SessionService] syncUserSession checkCachedUser True")
			end
		end

		local sessionService = self.props.sessionService
		local v5 = self.state.localPlayerUserId

		if p2 then
			local cachedUserId = self.props.getCachedUserId()
			v5 = cachedUserId or v5
			logger:info(
				"LocalPlayerManager:syncUserSession(checkCachedUser==true) localPlayerUserId: {}, cachedUserId: {}",
				v5,
				cachedUserId
			)
		end

		if not module6 then
			local function fn(p3)
				if defineFastFlag2 then
					print("[FLog::SessionService] handleL1WithUserId")
				end

				if sessionService:SessionExists(sessionType.StructuralIdentifier.Level1) then
					local metadata = sessionService:GetMetadata(
						sessionType.StructuralIdentifier.Level1,
						sessionType.Metadata.User.UserId
					)

					if metadata ~= p3 then
						if defineFastFlag2 then
							print("[FLog::SessionService] handleL1WithUserId expectedUserId " .. tostring(p3) .. " currentL1SessionUserId " .. tostring(metadata))
						end

						sessionService:SetSession(
							sessionService:GetRootSID(),
							sessionType.StructuralIdentifier.Level1,
							sessionType.Tag.Level1.Default
						)

						sessionService:SetMetadata(
							sessionType.StructuralIdentifier.Level1,
							sessionType.Metadata.User.UserId,
							p3
						)
					end
				else
					if defineFastFlag2 then
						print("LocalPlayerManager:syncUserSession, Level1 session is missing!")
					end

					logger:warning("LocalPlayerManager:syncUserSession, Level1 session is missing!")

					sessionService:SetSession(
						sessionService:GetRootSID(),
						sessionType.StructuralIdentifier.Level1,
						sessionType.Tag.Level1.LoggedOut
					)
				end
			end

			local function fn2()
				if defineFastFlag2 then
					print("[FLog::SessionService] handleL1WithNoUserId")
				end

				if
					not sessionService:SessionExists(sessionType.StructuralIdentifier.Level1)
					or sessionService:GetSessionTag(sessionType.StructuralIdentifier.Level1) == sessionType.Tag.Level1.Default
				then
					sessionService:SetSession(
						sessionService:GetRootSID(),
						sessionType.StructuralIdentifier.Level1,
						sessionType.Tag.Level1.LoggedOut
					)
				end
			end

			if v5 == nil then
				fn2()
			else
				fn(v5)
			end
		end
	end

	local sessionService = self.props.sessionService

	if self.props.runService:IsStudio() then
		sessionService:RemoveSession(sessionType.StructuralIdentifier.Level1)
	end

	self.syncUserSession(true)
end

function extended.render(props)
	local setUserMembershipType = props.props.setUserMembershipType

	local setUserHasRobloxSubscription2 = if fFlagEnableBlackbirdCheck then props.props.setUserHasRobloxSubscription else nil

	local v5 = defineFastFlag and {} or {
		PlayerRemovingConnection = Roact.createElement(module2, {
			event = Players.PlayerRemoving,
			callback = function()
				props:setState({
					hasLocalPlayer = Players.LocalPlayer ~= nil,
					localPlayerUserId = Roact.None
				})
			end
		}),
		PlayerAddedConnection = Roact.createElement(module2, {
			event = Players.PlayerAdded,
			callback = function()
				props:setState({
					hasLocalPlayer = Players.LocalPlayer ~= nil,
					localPlayerUserId = props.props.getLocalPlayerUserId() or Roact.None
				})
			end
		})
	}

	local v6 = defineFastFlag2 and {
		PlayerRemovingConnection = Roact.createElement(module2, {
			event = Players.PlayerRemoving,
			callback = function()
				print("[FLog::SessionService] Players.PlayerRemoving updateLocalPlayerState()")
				props.updateLocalPlayerState()
			end
		})
	} or v5

	if props.state.hasLocalPlayer then
		table.insert(v6, Roact.createElement(module2, {
			event = Players.LocalPlayer:GetPropertyChangedSignal("MembershipType"),
			callback = function()
				local localPlayer = Players.LocalPlayer
				setUserMembershipType(tostring(localPlayer.UserId), localPlayer.MembershipType)

				props.updateUserInfoToBacktrace()
			end
		}))

		if fFlagEnableBlackbirdCheck and game:GetEngineFeature("ReadHasRobloxSubscriptionLua") then
			table.insert(v6, Roact.createElement(module2, {
				event = Players.LocalPlayer:GetPropertyChangedSignal("HasRobloxSubscription"),
				callback = function()
					local localPlayer = Players.LocalPlayer
					local userId = tostring(localPlayer.UserId)
					local success, result = pcall(function()
						return localPlayer.HasRobloxSubscription
					end)

					if not success then
						mutedError("[LocalPlayerManager] Failed to read HasRobloxSubscription: " .. tostring(result))
					end

					setUserHasRobloxSubscription2(userId, success and result == true)
				end
			}))
		end
	end

	return Roact.createElement("Folder", {}, v6)
end

function extended:didMount()
	if self.state.hasLocalPlayer then
		self.props.fetchLocalUserData()
	end

	self.updateUserInfoToBacktrace()
	self.updateLocalPlayerState()
	self.localPlayerConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(self.fetchAndUpdateLocalPlayer)
end

function extended.didUpdate(data, p2, p3)
	if p3.localPlayerUserId ~= data.state.localPlayerUserId then
		data.syncUserSession()
	end

	if p2.countryCode ~= data.props.countryCode then
		data.updateUserInfoToBacktrace()
	end
end

function extended:willUnmount()
	if self.localPlayerConnection ~= nil then
		self.localPlayerConnection:Disconnect()
		self.localPlayerConnection = nil
	end
end

local v5 = roactServices.connect({
	sessionService = appSessionService,
	runService = appRunService
})(extended)

local v6 = RoactRodux.connect(not fFlagUseSignalsForCountryCode and function(p2, p3)
	local countryCode = p2.CountryCode
	return {
		countryCode = string.len(countryCode) > 0 and countryCode or "Unknown"
	}
end or nil, function(callback)
	return {
		setUserMembershipType = function(p2, p3)
			callback(module3(p2, p3))
		end,
		setUserHasRobloxSubscription = fFlagEnableBlackbirdCheck and function(p2, p3)
			callback(setUserHasRobloxSubscription(p2, p3))
		end or nil,
		fetchLocalUserData = function()
			callback(getLocalUser())
		end
	}
end)(v5)
local v7

if fFlagUseSignalsForCountryCode then
	v7 = React.memo(function(p2)
		local v8 = useSignalState(getCountryCodeStore(false).getCountryCode)
		return Roact.createElement(v6, Cryo.Dictionary.union(p2, {
			countryCode = string.len(v8) > 0 and v8 or "Unknown"
		}))
	end)
else
	v7 = v6
end

return v7
