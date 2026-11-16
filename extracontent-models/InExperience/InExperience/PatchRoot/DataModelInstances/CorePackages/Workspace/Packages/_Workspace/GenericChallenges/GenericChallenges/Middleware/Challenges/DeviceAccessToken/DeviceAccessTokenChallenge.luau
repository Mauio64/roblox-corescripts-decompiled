local HttpService = game:GetService("HttpService")
local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local React = require(parent.React)
local useState = React.useState
local useEffect = React.useEffect
local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLogging = RoactServiceTags.AppLogging
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local DeviceAccessChallengeEvent = require(script.Parent.DeviceAccessChallengeEvent)
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)

local GetFFlagLuaAppChallengeMoreTelemetryEnabled = require(GenericChallenges.Middleware.Flags.GetFFlagLuaAppChallengeMoreTelemetryEnabled)

local function DeviceAccessTokenChallenge(props)
	local v = useRoactService(AppLogging)

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
		v:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
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
				v:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
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
		v:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
			challengeId = props.challengeId,
			tokenType = jsonDecode.tokenType,
			errorCode = errorCode
		})
	end, {})

	local v2 = useSelector(function(p)
		return { screenSize = p.ScreenSize }
	end)

	local udim = UDim2.fromOffset(v2.screenSize.X, v2.screenSize.Y)

	local createElement = Roact.createElement

	local v3 = {
		Spinner = Roact.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large
		}),
		NavigationEvents = 0
	}
	local navigationEvents

	if GetFFlagLuaAppChallengeMoreTelemetryEnabled() then
		navigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
			onWillBlur = function()
				if not (state or state2) then
					v:logRobloxTelemetryEvent(DeviceAccessChallengeEvent, {}, {
						context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
						challengeId = props.challengeId,
						tokenType = jsonDecode.tokenType
					})
				end
			end
		})
	end

	v3.NavigationEvents = navigationEvents
	return createElement("Frame", { Size = udim, BackgroundTransparency = 0.2, Active = true }, v3)
end

return DeviceAccessTokenChallenge
