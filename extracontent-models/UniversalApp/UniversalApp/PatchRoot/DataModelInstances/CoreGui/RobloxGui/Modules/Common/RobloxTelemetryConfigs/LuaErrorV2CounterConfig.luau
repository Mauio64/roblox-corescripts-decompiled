local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local v3 = game:DefineFastInt("LuaErrorV2ThrottleHundredthPercentage", 0)

return {
	eventName = "LuaAppsError",
	description = "V2 Counter to for Lua App Error.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = v3,
	lastUpdated = {
		24,
		11,
		2
	}
}
