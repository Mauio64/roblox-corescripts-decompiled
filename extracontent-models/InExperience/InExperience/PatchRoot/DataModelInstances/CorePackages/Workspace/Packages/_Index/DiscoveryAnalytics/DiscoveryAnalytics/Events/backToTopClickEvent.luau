local TelemetryService = game:GetService("TelemetryService")

local v = {
	eventName = "backToTopClick",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppBackToTopClickEventThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 7, 22 },
	description = "User clicked the back to top button at the end of a scrollable surface"
}

return function(eventContext: string?)
	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" }
	})
end
