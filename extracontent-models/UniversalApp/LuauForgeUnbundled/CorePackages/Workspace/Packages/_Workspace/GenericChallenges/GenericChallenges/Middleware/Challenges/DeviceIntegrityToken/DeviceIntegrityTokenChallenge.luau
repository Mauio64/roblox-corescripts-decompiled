local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppHooks").useRoactService
local appLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactServiceTags").AppLogging
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local DeviceIntegrityChallengeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/DeviceIntegrityToken/DeviceIntegrityChallengeEvent")

local GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner")

local GetFFlagEnableNewDeviceIntegrityFailureHandling = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/GetFFlagEnableNewDeviceIntegrityFailureHandling")
local useEffect = React.useEffect
local ChallengeEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ChallengeEventConstants")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactUtils").Hooks.RoactRodux.useSelector
game:DefineFastInt("DeviceIntegrityNativeTimeoutMilliseconds", 450)

function LUAUFORGE_MODULE_GLOBALS_bZz_constructAccountServiceParams(p2)
	return HttpService:JSONEncode({ requestHash = p2 })
end

local function DeviceIntegrityTokenChallenge(props)
	local v5 = useRoactService(appLogging)

	useEffect(function()
		local jsonDecode = HttpService:JSONDecode(props.challengeMetadata)
		v5:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = props.challengeId,
			integrityType = jsonDecode.integrityType
		})

		local accountService = props.accountService

		if accountService and accountService:DeviceIntegrityAvailable() then
			local v6

			if GetFFlagEnableNewDeviceIntegrityFailureHandling() then
				local deviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
					requestHash = jsonDecode.requestHash,
					timeoutMillis = game:GetFastInt("DeviceIntegrityNativeTimeoutMilliseconds")
				})))

				if deviceIntegrityTokenYield == nil or deviceIntegrityTokenYield == "" then
					v5:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
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

				v6 = HttpService:JSONDecode(deviceIntegrityTokenYield)
			else
				v6 = HttpService:JSONDecode(accountService:GetDeviceIntegrityTokenYield(LUAUFORGE_MODULE_GLOBALS_bZz_constructAccountServiceParams(jsonDecode.requestHash)))
			end

			props.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = v6.token,
				integrityType = jsonDecode.integrityType
			}))

			v5:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = props.challengeId,
				integrityType = jsonDecode.integrityType,
				result = v6.result
			})
		elseif GetFFlagEnableNewDeviceIntegrityFailureHandling() then
			v5:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
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
			v5:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = props.challengeId,
				integrityType = jsonDecode.integrityType
			})
		end
	end, {})
	local v6 = useSelector(function(p2)
		return { screenSize = p2.ScreenSize }
	end)

	local udim = UDim2.fromOffset(v6.screenSize.X, v6.screenSize.Y)

	if GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner() then
		return React.createElement("Frame", {
			Size = udim,
			BackgroundTransparency = 1,
			Active = true
		}, {
			Spinner = React.createElement(loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				size = iconSize.Large
			})
		})
	end

	return React.createElement("Frame", {
		Size = udim,
		BackgroundTransparency = 0.2,
		Active = true
	}, {
		Spinner = React.createElement(loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = iconSize.Large
		})
	})
end

return DeviceIntegrityTokenChallenge
