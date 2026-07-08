local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local v3 = game:DefineFastInt("LuaCoreScriptsErrorV2ThrottleHundredthPercentage", 0)

return {
	eventName = "LuaCoreScriptsError",
	description = "V2 Counter to for Lua CoreScripts Error.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = v3,
	lastUpdated = {
		25,
		1,
		29
	}
}
