local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("FIntCrossExperienceEventThrottleHunderedthsPercent", 10000)

function logEvent(eventName: string, customFields)
	TelemetryService:LogEvent({
		eventName = eventName,
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 6, 30 },
		description = "Cross Experience Analytics Events"
	}, { customFields = customFields })
end

return { logEvent = logEvent }
