local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local defineFastInt = game:DefineFastInt("LuaErrorV2ThrottleHundredthPercentage", 0)

return {
	eventName = "LuaAppsError",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 11, 2 },
	description = "V2 Counter to for Lua App Error."
}
