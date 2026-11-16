local TelemetryService = game:GetService("TelemetryService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local parent = script:FindFirstAncestor("InteractionFeedback").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("HapticTriggerAttemptThrottleHundredthsPercent", 0)

local interface = t.interface({
	hapticType = t.string,
	contextKey = t.string,
	interactionType = t.string
})

return function(customFields, eventContext: string)
	if not eventContext then
		DiscoveryEventErrorLogger.reportError("HapticTriggerAttemptInvalidInterface", "event is missing context")
	end

	local v, v2 = interface(customFields)

	if not v then
		DiscoveryEventErrorLogger.reportError("HapticTriggerAttemptInvalidInterface", v2)
	end

	local hapticStrength = UserGameSettings.HapticStrength
	customFields.hapticEnabledByUser = hapticStrength > 0
	customFields.hapticStrength = hapticStrength
	TelemetryService:LogEvent({
		eventName = "hapticTriggerAttempt",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 10, 21 },
		description = "User has taken an action that may have triggered haptic feedback"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addOSInfo", "addSessionInfo" },
		customFields = customFields
	})
end
