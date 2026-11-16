local HttpService = game:GetService("HttpService")

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppHooks").useRoactService
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactUtils").Hooks.RoactRodux.useSelector
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")
local useState = React.useState
local useEffect = React.useEffect
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactNavigation")
local appLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactServiceTags").AppLogging
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local DeviceAccessChallengeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/DeviceAccessToken/DeviceAccessChallengeEvent")
local ChallengeEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ChallengeEventConstants")

local GetFFlagLuaAppChallengeMoreTelemetryEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/GetFFlagLuaAppChallengeMoreTelemetryEnabled")

local function DeviceAccessTokenChallenge(props)
	local v5 = useRoactService(appLogging)

	local jsonDecode = HttpService:JSONDecode(props.challengeMetadata)
	local state, setState, state2, setState2

	if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
		state, setState = useState(false)
		state2, setState2 = useState(false)
	else
		setState = nil
		setState2 = nil
		state = nil
		state2 = nil
	end

	useEffect(function()
		v5:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = props.challengeId,
			tokenType = jsonDecode.tokenType
		})

		local accountService = props.accountService
		local errorCode

		if accountService and accountService:DeviceAccessTokenAvailable() then
			local jsonDecode2 = HttpService:JSONDecode(accountService:GetDeviceAccessToken())
			errorCode = jsonDecode2.errorCode

			if errorCode == nil or errorCode == "" then
				jsonDecode2.accessToken.tokenType = jsonDecode.tokenType

				if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
					setState(true)
				end

				props.onChallengeCompleted(HttpService:JSONEncode(jsonDecode2.accessToken))
				v5:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
					context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
					challengeId = props.challengeId,
					tokenType = jsonDecode.tokenType
				})

				return
			end
		end

		if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
			setState2(true)
		end

		props.onChallengeFailed(errorCode)
		v5:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
			challengeId = props.challengeId,
			tokenType = jsonDecode.tokenType,
			errorCode = errorCode
		})
	end, {})

	local v6 = useSelector(function(p2)
		return { screenSize = p2.ScreenSize }
	end)

	local udim = UDim2.fromOffset(v6.screenSize.X, v6.screenSize.Y)

	local createElement = Roact.createElement

	local v9 = {
		Spinner = Roact.createElement(loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = iconSize.Large
		}),
		NavigationEvents = 0
	}
	local v10

	if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
		v10 = Roact.createElement(RoactNavigation.NavigationEvents, {
			onWillBlur = function()
				if not (state or state2) then
					v5:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
						context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
						challengeId = props.challengeId,
						tokenType = jsonDecode.tokenType
					})
				end
			end
		})
	end

	v9.NavigationEvents = v10
	return createElement("Frame", {
		Size = udim,
		BackgroundTransparency = 0.2,
		Active = true
	}, v9)
end

return DeviceAccessTokenChallenge
