local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastInt("LuaAppBackToTopClickEventThrottlingHundredthsPercent", 10000)
local t1 = {
	eventName = "backToTopClick",
	description = "User clicked the back to top button at the end of a scrollable surface",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = v2,
	lastUpdated = {
		26,
		7,
		22
	}
}

return function(s1: string?) -- line: 14
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		}
	})
end
