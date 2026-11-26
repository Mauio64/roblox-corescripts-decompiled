local TelemetryService = game:GetService("TelemetryService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InteractionFeedback/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("HapticTriggerAttemptThrottleHundredthsPercent", 0)

local interface = t.interface({
	hapticType = t.string,
	contextKey = t.string,
	interactionType = t.string
})

return function(p2, p3)
	if not p3 then
		discoveryEventErrorLogger.reportError(
			"HapticTriggerAttemptInvalidInterface",
			"event is missing context"
		)
	end

	local v5, v6 = interface(p2)

	if not v5 then
		discoveryEventErrorLogger.reportError("HapticTriggerAttemptInvalidInterface", v6)
	end

	local hapticStrength = UserGameSettings.HapticStrength
	p2.hapticEnabledByUser = hapticStrength > 0
	p2.hapticStrength = hapticStrength
	TelemetryService:LogEvent({
		eventName = "hapticTriggerAttempt",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 10, 21 },
		description = "User has taken an action that may have triggered haptic feedback"
	}, {
		eventContext = p3,
		standardizedFields = { "addOSInfo", "addSessionInfo" },
		customFields = p2
	})
end
