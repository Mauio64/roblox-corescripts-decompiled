local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("LuaAppItemImpressionsEventThrottlingHundredthsPercent", 10000)

local function sduiCustomImpressionsEvent(eventName: string, eventContext: string, customFields)
	TelemetryService:LogEvent({
		eventName = eventName,
		backends = { "EventIngest", "Points" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 26, 3, 17 },
		description = `SDUI custom impression event: {eventName}`
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end

return sduiCustomImpressionsEvent
