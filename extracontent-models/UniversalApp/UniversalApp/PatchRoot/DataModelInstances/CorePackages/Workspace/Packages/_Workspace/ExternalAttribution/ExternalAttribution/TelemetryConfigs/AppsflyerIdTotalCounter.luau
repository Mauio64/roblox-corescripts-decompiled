local ExternalAttribution = script:FindFirstAncestor("ExternalAttribution")
local ExternalAttributionParent = ExternalAttribution.Parent
local GetFIntLuaAppsAppsflyerIdCounterThrottle = require(ExternalAttribution.Flags).GetFIntLuaAppsAppsflyerIdCounterThrottle
local LoggingProtocol = require(ExternalAttributionParent.LoggingProtocol)

return {
	eventName = "luaAppsAppsflyerIdTotal",
	description = "Counter to track total Appsflyer ID generation on Lua Apps.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = GetFIntLuaAppsAppsflyerIdCounterThrottle(),
	lastUpdated = {
		24,
		7,
		30
	}
}
