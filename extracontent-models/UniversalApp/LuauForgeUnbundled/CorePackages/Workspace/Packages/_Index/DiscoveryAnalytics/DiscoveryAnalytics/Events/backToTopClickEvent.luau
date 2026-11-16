local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "backToTopClick",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppBackToTopClickEventThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 7, 22 },
	description = "User clicked the back to top button at the end of a scrollable surface"
}

return function(p2)
	TelemetryService:LogEvent(v5, {
		eventContext = p2,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" }
	})
end
