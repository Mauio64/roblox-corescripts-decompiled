local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("FIntCrossExperienceEventThrottleHunderedthsPercent", 10000)

function LUAUFORGE_MODULE_GLOBALS_bpQ_logEvent(p2, p3)
	TelemetryService:LogEvent({
		eventName = p2,
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 6, 30 },
		description = "Cross Experience Analytics Events"
	}, { customFields = p3 })
end

return { logEvent = LUAUFORGE_MODULE_GLOBALS_bpQ_logEvent }
