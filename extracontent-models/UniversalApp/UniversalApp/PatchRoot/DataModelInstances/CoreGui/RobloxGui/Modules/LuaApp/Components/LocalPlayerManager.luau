local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppRunService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppRunService
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local Loggers = require(CorePackages.Workspace.Packages.Loggers)
local Logger = Loggers.Logger
local mutedError = Loggers.mutedError
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local SetUserMembershipType = require(Modules.LuaApp.Actions.SetUserMembershipType)
local SetUserHasRobloxSubscription = require(CorePackages.Workspace.Packages.UserLib).Actions.SetUserHasRobloxSubscription
local GetLocalUser = require(CorePackages.Workspace.Packages.UserLib).Thunks.GetLocalUser
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local FFlagEnableBlackbirdCheck = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdCheck
local v19 = game:DefineFastFlag("FixWrongLoggedOutSessionSwitch", false)
local v20 = game:DefineFastFlag("TestAndroidWrongLoggedInIssue", false)
local FFlagEnableL1SessionStateEngineOwned = require(Modules.LuaApp.Flags.FFlagEnableL1SessionStateEngineOwned)
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)
local v23 = Roact.Component:extend("LocalPlayerManager")

v23.defaultProps = {
	backtraceReporter = nil,
	getLocalPlayerUserId = function() -- line: 33
		-- upvalues: Players (copy)
		local v25 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if v25 == nil or v25 <= 0 then
			return nil
		end

		return (tostring(v25))
	end,
	getCachedUserId = function() -- line: 43
		-- upvalues: User (copy)
		local userId = User.fromLocalStorage().userId

		if userId > 0 then
			return (tostring(userId))
		end

		return nil
	end
}

function v23.init(p1) -- line: 59
	-- upvalues: Players (copy), LuaAppBacktraceReporter (copy), v20 (copy), Roact (copy), Logger (copy), FFlagEnableL1SessionStateEngineOwned (copy), SessionType (copy)
	p1:setState({
		hasLocalPlayer = Players.LocalPlayer ~= nil,
		localPlayerUserId = p1.props.getLocalPlayerUserId()
	})
	p1.backtraceReporter = p1.props.backtraceReporter or LuaAppBacktraceReporter

	function p1.fetchAndUpdateLocalPlayer() -- line: 72
		-- upvalues: p1 (copy)
		p1.props.fetchLocalUserData()
		p1.updateUserInfoToBacktrace()
		p1.updateLocalPlayerState()
	end
	function p1.updateLocalPlayerState() -- line: 78
		-- upvalues: p1 (copy), v20 (copy), Roact (copy), Players (copy)
		local v41 = p1.props.getLocalPlayerUserId()

		if v20 then
			print("[FLog::SessionService] currentLocalPlayerId " .. tostring(v41))
		end

		if v41 ~= p1.state.localPlayerUserId then
			p1:setState({
				localPlayerUserId = v41 or Roact.None,
				hasLocalPlayer = Players.LocalPlayer ~= nil
			})
		end
	end
	function p1.updateUserInfoToBacktrace() -- line: 91
		-- upvalues: Players (copy), p1 (copy)
		local LocalPlayer = Players.LocalPlayer
		local v43 = if LocalPlayer ~= nil and not (LocalPlayer.UserId <= 0) then {
			UserLoggedIn = true,
			UserMembershipType = tostring(LocalPlayer.MembershipType),
			UserIsUnder13 = LocalPlayer:GetUnder13(),
			CountryCode = p1.props.countryCode
		} else {
			UserLoggedIn = false,
			UserMembershipType = "Unknown",
			UserIsUnder13 = "Unknown",
			CountryCode = "Unknown"
		}

		p1.backtraceReporter:updateSharedAttributes(v43)
	end
	function p1.syncUserSession(p2) -- line: 114
		-- upvalues: v20 (copy), p1 (copy), Logger (copy), FFlagEnableL1SessionStateEngineOwned (copy), SessionType (copy)
		if v20 then
			print("[FLog::SessionService] syncUserSession()")

			if p2 then
				print("[FLog::SessionService] syncUserSession checkCachedUser True")
			end
		end

		local sessionService = p1.props.sessionService
		local localPlayerUserId = p1.state.localPlayerUserId

		if p2 then
			local v47 = p1.props.getCachedUserId()

			if v47 then
				localPlayerUserId = v47
			end

			Logger:info("LocalPlayerManager:syncUserSession(checkCachedUser==true) localPlayerUserId: {}, cachedUserId: {}", localPlayerUserId, v47)
		end

		if not FFlagEnableL1SessionStateEngineOwned then
			if localPlayerUserId ~= nil then
				(function(p3) -- line: 139
					-- upvalues: v20 (copy), sessionService (copy), SessionType (copy), Logger (copy)
					if v20 then
						print("[FLog::SessionService] handleL1WithUserId")
					end

					if sessionService:SessionExists(SessionType.StructuralIdentifier.Level1) then
						local Metadata = sessionService:GetMetadata(SessionType.StructuralIdentifier.Level1, SessionType.Metadata.User.UserId)

						if Metadata ~= p3 then
							if v20 then
								print("[FLog::SessionService] handleL1WithUserId expectedUserId " .. tostring(p3) .. " currentL1SessionUserId " .. tostring(Metadata))
							end

							sessionService:SetSession(sessionService:GetRootSID(), SessionType.StructuralIdentifier.Level1, SessionType.Tag.Level1.Default)
							sessionService:SetMetadata(SessionType.StructuralIdentifier.Level1, SessionType.Metadata.User.UserId, p3)

							return
						end
					else
						if v20 then
							print("LocalPlayerManager:syncUserSession, Level1 session is missing!")
						end

						Logger:warning("LocalPlayerManager:syncUserSession, Level1 session is missing!")
						sessionService:SetSession(sessionService:GetRootSID(), SessionType.StructuralIdentifier.Level1, SessionType.Tag.Level1.LoggedOut)
					end
				end)(localPlayerUserId)

				return
			end;

			(function() -- line: 187
				-- upvalues: v20 (copy), sessionService (copy), SessionType (copy)
				if v20 then
					print("[FLog::SessionService] handleL1WithNoUserId")
				end

				if not sessionService:SessionExists(SessionType.StructuralIdentifier.Level1) or sessionService:GetSessionTag(SessionType.StructuralIdentifier.Level1) == SessionType.Tag.Level1.Default then
					sessionService:SetSession(sessionService:GetRootSID(), SessionType.StructuralIdentifier.Level1, SessionType.Tag.Level1.LoggedOut)
				end
			end)()
		end
	end

	local sessionService = p1.props.sessionService

	if p1.props.runService:IsStudio() then
		sessionService:RemoveSession(SessionType.StructuralIdentifier.Level1)
	end

	p1.syncUserSession(true)
end
function v23.render(p4) -- line: 225
	-- upvalues: FFlagEnableBlackbirdCheck (copy), v19 (copy), Roact (copy), ExternalEventConnection (copy), Players (copy), v20 (copy), mutedError (copy)
	local setUserMembershipType = p4.props.setUserMembershipType
	local v31 = if not FFlagEnableBlackbirdCheck then nil else p4.props.setUserHasRobloxSubscription
	local v32 = if not v19 then {
		PlayerRemovingConnection = Roact.createElement(ExternalEventConnection, {
			event = Players.PlayerRemoving,
			callback = function() -- line: 236
				-- upvalues: p4 (copy), Players (copy), Roact (copy)
				p4:setState({
					hasLocalPlayer = Players.LocalPlayer ~= nil,
					localPlayerUserId = Roact.None
				})
			end
		}),
		PlayerAddedConnection = Roact.createElement(ExternalEventConnection, {
			event = Players.PlayerAdded,
			callback = function() -- line: 245
				-- upvalues: p4 (copy), Players (copy), Roact (copy)
				p4:setState({
					hasLocalPlayer = Players.LocalPlayer ~= nil,
					localPlayerUserId = p4.props.getLocalPlayerUserId() or Roact.None
				})
			end
		})
	} else {}

	if v20 then
		v32 = {
			PlayerRemovingConnection = Roact.createElement(ExternalEventConnection, {
				event = Players.PlayerRemoving,
				callback = function() -- line: 258
					-- upvalues: p4 (copy)
					print("[FLog::SessionService] Players.PlayerRemoving updateLocalPlayerState()")
					p4.updateLocalPlayerState()
				end
			})
		}
	end

	if p4.state.hasLocalPlayer then
		table.insert(v32, Roact.createElement(ExternalEventConnection, {
			event = Players.LocalPlayer:GetPropertyChangedSignal("MembershipType"),
			callback = function() -- line: 271
				-- upvalues: Players (copy), setUserMembershipType (copy), p4 (copy)
				local LocalPlayer = Players.LocalPlayer
				local str = tostring(LocalPlayer.UserId)

				setUserMembershipType(str, LocalPlayer.MembershipType)
				p4.updateUserInfoToBacktrace()
			end
		}))

		if FFlagEnableBlackbirdCheck and game:GetEngineFeature("ReadHasRobloxSubscriptionLua") then
			table.insert(v32, Roact.createElement(ExternalEventConnection, {
				event = Players.LocalPlayer:GetPropertyChangedSignal("HasRobloxSubscription"),
				callback = function() -- line: 286
					-- upvalues: Players (copy), mutedError (copy), v31 (copy)
					local LocalPlayer = Players.LocalPlayer
					local str = tostring(LocalPlayer.UserId)
					local ok, result = pcall(function() -- line: 289
						-- upvalues: LocalPlayer (copy)
						return LocalPlayer.HasRobloxSubscription
					end)

					if not ok then
						mutedError("[LocalPlayerManager] Failed to read HasRobloxSubscription: " .. tostring(result))
					end

					v31(str, ok and result == true)
				end
			}))
		end
	end

	return Roact.createElement("Folder", {}, v32)
end
function v23.didMount(p5) -- line: 306
	-- upvalues: Players (copy)
	if p5.state.hasLocalPlayer then
		p5.props.fetchLocalUserData()
	end

	p5.updateUserInfoToBacktrace()
	p5.updateLocalPlayerState()
	p5.localPlayerConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(p5.fetchAndUpdateLocalPlayer)
end
function v23.didUpdate(p6, p7, p8) -- line: 316
	if p8.localPlayerUserId ~= p6.state.localPlayerUserId then
		p6.syncUserSession()
	end

	if p7.countryCode ~= p6.props.countryCode then
		p6.updateUserInfoToBacktrace()
	end
end
function v23.willUnmount(p9) -- line: 326
	if p9.localPlayerConnection ~= nil then
		p9.localPlayerConnection:Disconnect()
		p9.localPlayerConnection = nil
	end
end

local v24 = RoactServices.connect({
	sessionService = AppSessionService,
	runService = AppRunService
})(v23)

return RoactRodux.connect(function(p10, _) -- line: 338
	return {
		countryCode = string.len(p10.CountryCode) > 0 and p10.CountryCode or "Unknown"
	}
end, function(p12) -- line: 342
	-- upvalues: SetUserMembershipType (copy), FFlagEnableBlackbirdCheck (copy), SetUserHasRobloxSubscription (copy), GetLocalUser (copy)
	return {
		setUserMembershipType = function(p13, p14) -- line: 344
			-- upvalues: p12 (copy), SetUserMembershipType (copy)
			p12(SetUserMembershipType(p13, p14))
		end,
		setUserHasRobloxSubscription = if not FFlagEnableBlackbirdCheck then nil else function(p15, p16) -- line: 348
			-- upvalues: p12 (copy), SetUserHasRobloxSubscription (copy)
			p12(SetUserHasRobloxSubscription(p15, p16))
		end,
		fetchLocalUserData = function() -- line: 352
			-- upvalues: p12 (copy), GetLocalUser (copy)
			p12(GetLocalUser())
		end
	}
end)(v24)
