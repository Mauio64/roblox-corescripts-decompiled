local getFIntLuaAppsAppsflyerIdCounterThrottle = require("@luauforge/bundled/fBD").GetFIntLuaAppsAppsflyerIdCounterThrottle
return {
	eventName = "luaAppsAppsflyerIdTotal",
	backends = { require("@luauforge/bundled/fBz").TelemetryBackends.Counter },
	throttlingPercentage = getFIntLuaAppsAppsflyerIdCounterThrottle(),
	lastUpdated = { 24, 7, 30 },
	description = "Counter to track total Appsflyer ID generation on Lua Apps."
}
