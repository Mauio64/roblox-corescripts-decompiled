local getFIntLuaAppsAppsflyerIdCounterThrottle = require("@luauforge/bundled/gfW").GetFIntLuaAppsAppsflyerIdCounterThrottle
return {
	eventName = "luaAppsAppsflyerIdFailure",
	backends = { require("@luauforge/bundled/gfS").TelemetryBackends.Counter },
	throttlingPercentage = getFIntLuaAppsAppsflyerIdCounterThrottle(),
	lastUpdated = { 24, 7, 30 },
	description = "Counter to track failed Appsflyer ID generation on Lua Apps."
}
