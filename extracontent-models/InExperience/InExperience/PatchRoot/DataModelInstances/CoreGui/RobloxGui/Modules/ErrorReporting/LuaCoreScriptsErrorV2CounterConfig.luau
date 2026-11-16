local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local defineFastInt = game:DefineFastInt("LuaCoreScriptsErrorV2ThrottleHundredthPercentage", 0)

return {
	eventName = "LuaCoreScriptsError",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 1, 29 },
	description = "V2 Counter to for Lua CoreScripts Error."
}
