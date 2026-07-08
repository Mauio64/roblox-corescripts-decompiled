local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastInt("FIntCrossExperienceEventThrottleHunderedthsPercent", 10000)

function logEvent(s1: string, t1: {[any]: any}) -- line: 7
	-- upvalues: v2 (copy), TelemetryService (copy)
	local t2 = {
		description = "Cross Experience Analytics Events",
		eventName = s1,
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			2025,
			6,
			30
		}
	}

	TelemetryService:LogEvent(t2, {
		customFields = t1
	})
end

return {
	logEvent = logEvent
}
