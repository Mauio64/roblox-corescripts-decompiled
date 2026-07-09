local ExternalAttribution = script:FindFirstAncestor("ExternalAttribution")
local ExternalAttributionParent = ExternalAttribution.Parent
local GetFIntLuaAppsAppsflyerIdCounterThrottle = require(ExternalAttribution.Flags).GetFIntLuaAppsAppsflyerIdCounterThrottle
local LoggingProtocol = require(ExternalAttributionParent.LoggingProtocol)

return {
	eventName = "luaAppsAppsflyerIdFailure",
	description = "Counter to track failed Appsflyer ID generation on Lua Apps.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = GetFIntLuaAppsAppsflyerIdCounterThrottle(),
	lastUpdated = {
		24,
		7,
		30
	}
}
