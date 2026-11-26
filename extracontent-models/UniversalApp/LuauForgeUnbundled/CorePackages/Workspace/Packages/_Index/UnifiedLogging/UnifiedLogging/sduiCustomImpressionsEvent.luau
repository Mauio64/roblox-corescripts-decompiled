local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("LuaAppItemImpressionsEventThrottlingHundredthsPercent", 10000)

local function sduiCustomImpressionsEvent(p2, p3, p4)
	TelemetryService:LogEvent({
		eventName = p2,
		backends = { "EventIngest", "Points" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 3, 17 },
		description = `SDUI custom impression event: {p2}`
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p4
	})
end

return sduiCustomImpressionsEvent
