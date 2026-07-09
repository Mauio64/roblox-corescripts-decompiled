local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(CorePackages.Packages.React)
local useState = React.useState
local useEffect = React.useEffect
local Roact = require(Modules.Common.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local DeviceAccessChallengeEvent = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.DeviceAccessChallengeEvent)
local ChallengeEventConstants = require(Modules.LuaApp.Components.Challenge.ChallengeEventConstants)
local GetFFlagLuaAppChallengeMoreTelemetryEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppChallengeMoreTelemetryEnabled)

local function DeviceAccessTokenChallenge(t1: {[any]: any}) -- line: 34
	-- upvalues: useRoactService (copy), AppLogging (copy), HttpService (copy), GetFFlagLuaAppChallengeMoreTelemetryEnabled (copy), useState (copy), useEffect (copy), DeviceAccessChallengeEvent (copy), ChallengeEventConstants (copy), useSelector (copy), Roact (copy), Loading (copy), IconSize (copy), RoactNavigation (copy)
	local v20 = useRoactService(AppLogging)
	local u21 = nil
	local u22 = nil
	local u23 = nil
	local u24 = nil
	local data = HttpService:JSONDecode(t1.challengeMetadata)

	if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
		local v26, v27 = useState(false)

		u21 = v26
		u22 = v27

		local v28, v29 = useState(false)

		u23 = v28
		u24 = v29
	end

	useEffect(function() -- line: 46
		-- upvalues: v20 (copy), DeviceAccessChallengeEvent (copy), ChallengeEventConstants (copy), t1 (copy), data (copy), HttpService (copy), GetFFlagLuaAppChallengeMoreTelemetryEnabled (copy), u22 (ref), u24 (ref)
		v20:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = t1.challengeId,
			tokenType = data.tokenType
		})

		local accountService = t1.accountService
		local errorCode = nil

		if accountService and accountService:DeviceAccessTokenAvailable() then
			local data2 = HttpService:JSONDecode(accountService:GetDeviceAccessToken())

			errorCode = data2.errorCode

			if errorCode == nil or errorCode == "" then
				data2.accessToken.tokenType = data.tokenType

				if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
					u22(true)
				end

				t1.onChallengeCompleted(HttpService:JSONEncode(data2.accessToken))
				v20:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
					challengeId = t1.challengeId,
					tokenType = data.tokenType
				})

				return
			end
		end

		if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
			u24(true)
		end

		t1.onChallengeFailed(errorCode)
		v20:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
			challengeId = t1.challengeId,
			tokenType = data.tokenType,
			errorCode = errorCode
		})
	end, {})

	local v30 = useSelector(function(p1) -- line: 86
		return {
			screenSize = p1.ScreenSize
		}
	end)
	local uDim2 = UDim2.fromOffset(v30.screenSize.X, v30.screenSize.Y)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0.2,
		Active = true,
		Size = uDim2
	}, {
		Spinner = Roact.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large
		}),
		NavigationEvents = if not GetFFlagLuaAppChallengeMoreTelemetryEnabled() then nil else Roact.createElement(RoactNavigation.NavigationEvents, {
			onWillBlur = function() -- line: 106
				-- upvalues: u21 (ref), u23 (ref), v20 (copy), DeviceAccessChallengeEvent (copy), ChallengeEventConstants (copy), t1 (copy), data (copy)
				if not u21 and not u23 then
					v20:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
						context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
						challengeId = t1.challengeId,
						tokenType = data.tokenType
					})
				end
			end
		})
	})
end

return DeviceAccessTokenChallenge
