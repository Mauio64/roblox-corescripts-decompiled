local v1 = game:DefineFastInt("LuaAppSessionWithErrorThrottlePercentage", 100)

return {
	eventName = "LuaAppSessionWithError",
	description = "Counting Lua App Session with Error.",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = v1,
	lastUpdated = {
		26,
		2,
		23
	}
}
