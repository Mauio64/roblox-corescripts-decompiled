local HttpService = game:GetService("HttpService")
local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericChallengesParent = GenericChallenges.Parent
local React = require(GenericChallengesParent.React)
local useRoactService = require(GenericChallengesParent.RobloxAppHooks).useRoactService
local AppLogging = require(GenericChallengesParent.RoactServiceTags).AppLogging
local Foundation = require(GenericChallengesParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local DeviceIntegrityChallengeEvent = require(script.Parent.DeviceIntegrityChallengeEvent)
local GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner = require(GenericChallenges.Middleware.Flags.GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner)
local GetFFlagEnableNewDeviceIntegrityFailureHandling = require(GenericChallenges.Middleware.Flags.GetFFlagEnableNewDeviceIntegrityFailureHandling)
local useEffect = React.useEffect
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local useSelector = require(GenericChallengesParent.RoactUtils).Hooks.RoactRodux.useSelector

game:DefineFastInt("DeviceIntegrityNativeTimeoutMilliseconds", 450)

function constructAccountServiceParams(s1: string) -- line: 21
	-- upvalues: HttpService (copy)
	return HttpService:JSONEncode({
		requestHash = s1
	})
end

local function DeviceIntegrityTokenChallenge(t1: {[any]: any}) -- line: 54
	-- upvalues: useRoactService (copy), AppLogging (copy), useEffect (copy), HttpService (copy), DeviceIntegrityChallengeEvent (copy), ChallengeEventConstants (copy), GetFFlagEnableNewDeviceIntegrityFailureHandling (copy), useSelector (copy), GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner (copy), React (copy), Loading (copy), IconSize (copy)
	local v19 = useRoactService(AppLogging)

	useEffect(function() -- line: 57
		-- upvalues: HttpService (copy), t1 (copy), v19 (copy), DeviceIntegrityChallengeEvent (copy), ChallengeEventConstants (copy), GetFFlagEnableNewDeviceIntegrityFailureHandling (copy)
		local data = HttpService:JSONDecode(t1.challengeMetadata)

		v19:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInitialized,
			challengeId = t1.challengeId,
			integrityType = data.integrityType
		})

		local accountService = t1.accountService

		if accountService and accountService:DeviceIntegrityAvailable() then
			local data2

			if GetFFlagEnableNewDeviceIntegrityFailureHandling() then
				local DeviceIntegrityTokenYield = accountService:GetDeviceIntegrityTokenYield((HttpService:JSONEncode({
					requestHash = data.requestHash,
					timeoutMillis = game:GetFastInt("DeviceIntegrityNativeTimeoutMilliseconds")
				})))

				if DeviceIntegrityTokenYield == nil or DeviceIntegrityTokenYield == "" then
					v19:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
						context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
						challengeId = t1.challengeId,
						integrityType = data.integrityType
					})
					t1.onChallengeCompleted(HttpService:JSONEncode({
						redemptionToken = "",
						integrityType = data.integrityType
					}))

					return
				end

				data2 = HttpService:JSONDecode(DeviceIntegrityTokenYield)
			else
				data2 = HttpService:JSONDecode(accountService:GetDeviceIntegrityTokenYield(constructAccountServiceParams(data.requestHash)))
			end

			t1.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = data2.token,
				integrityType = data.integrityType
			}))
			v19:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = t1.challengeId,
				integrityType = data.integrityType,
				result = data2.result
			})

			return
		end

		if GetFFlagEnableNewDeviceIntegrityFailureHandling() then
			v19:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = t1.challengeId,
				integrityType = data.integrityType
			})
			t1.onChallengeCompleted(HttpService:JSONEncode({
				redemptionToken = "",
				integrityType = data.integrityType
			}))

			return
		end

		t1.onChallengeFailed()
		v19:logRobloxTelemetryEvent(DeviceIntegrityChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
			challengeId = t1.challengeId,
			integrityType = data.integrityType
		})
	end, {})

	local v20 = useSelector(function(p1) -- line: 131
		return {
			screenSize = p1.ScreenSize
		}
	end)
	local uDim2 = UDim2.fromOffset(v20.screenSize.X, v20.screenSize.Y)

	if GetFFlagEnableTransparentDeviceIntegrityChallengeSpinner() then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Active = true,
			Size = uDim2
		}, {
			Spinner = React.createElement(Loading, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				size = IconSize.Large
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 0.2,
		Active = true,
		Size = uDim2
	}, {
		Spinner = React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = IconSize.Large
		})
	})
end

return DeviceIntegrityTokenChallenge
