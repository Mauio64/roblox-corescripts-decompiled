local HttpService = game:GetService("HttpService")
local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLogging = RoactServiceTags.AppLogging
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local DeviceIntegrityChallengeEvent = require(script.Parent.DeviceIntegrityChallengeEvent)

local GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner = require(GenericChallenges.Middleware.Flags.GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner)

local GetFFlagEnableNewDeviceIntegrityFailureHandling = require(GenericChallenges.Middleware.Flags.GetFFlagEnableNewDeviceIntegrityFailureHandling)
local useEffect = React.useEffect
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
game:DefineFastInt("DeviceIntegrityNativeTimeoutMilliseconds", 450)

function constructAccountServiceParams(requestHash: string)
	return HttpService:JSONEncode({ requestHash = requestHash })
end

local function DeviceIntegrityTokenChallenge(props)
	local v = useRoactService(AppLogging)

	useEffect(function()
		local jsonDecode = HttpService:JSONDecode(props.challengeMetadata)
		v:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = props.challengeId,
			integrityType = jsonDecode.integrityType
		})

		local accountService = props.accountService

		if accountService and accountService:DeviceIntegrityAvailable() then
			local v2

			if GetFFlagEnableNewDeviceIntegrityFailureHandling() then
				local deviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
					requestHash = jsonDecode.requestHash,
					timeoutMillis = game:GetFastInt("DeviceIntegrityNativeTimeoutMilliseconds")
				})))

				if deviceIntegrityTokenYield == nil or deviceIntegrityTokenYield == "" then
					v:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
						context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
						challengeId = props.challengeId,
						integrityType = jsonDecode.integrityType
					})

					props.onChallengeCompleted(HttpService:JSONEncode({
						redemptionToken = "",
						integrityType = jsonDecode.integrityType
					}))

					return
				end

				v2 = HttpService:JSONDecode(deviceIntegrityTokenYield)
			else
				v2 = HttpService:JSONDecode(accountService:GetDeviceIntegrityTokenYield(constructAccountServiceParams(jsonDecode.requestHash)))
			end

			props.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = v2.token,
				integrityType = jsonDecode.integrityType
			}))

			v:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = props.challengeId,
				integrityType = jsonDecode.integrityType,
				result = v2.result
			})
		elseif GetFFlagEnableNewDeviceIntegrityFailureHandling() then
			v:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				integrityType = jsonDecode.integrityType
			})

			props.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = "",
				integrityType = jsonDecode.integrityType
			}))
		else
			props.onChallengeFailed()
			v:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				integrityType = jsonDecode.integrityType
			})
		end
	end, {})
	local v2 = useSelector(function(p)
		return { screenSize = p.ScreenSize }
	end)

	local udim = UDim2.fromOffset(v2.screenSize.X, v2.screenSize.Y)

	if GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner() then
		return React.createElement("Frame", {
			Size = udim,
			BackgroundTransparency = 1,
			Active = true
		}, {
			Spinner = React.createElement(Loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				size = IconSize.Large
			})
		})
	end

	return React.createElement("Frame", { Size = udim, BackgroundTransparency = 0.2, Active = true }, {
		Spinner = React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large
		})
	})
end

return DeviceIntegrityTokenChallenge
