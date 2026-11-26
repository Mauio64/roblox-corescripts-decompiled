return {
	eventName = "LuaAppSessionWithError",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = game:DefineFastInt("LuaAppSessionWithErrorThrottlePercentage", 100),
	lastUpdated = { 26, 2, 23 },
	description = "Counting Lua App Session with Error."
}
