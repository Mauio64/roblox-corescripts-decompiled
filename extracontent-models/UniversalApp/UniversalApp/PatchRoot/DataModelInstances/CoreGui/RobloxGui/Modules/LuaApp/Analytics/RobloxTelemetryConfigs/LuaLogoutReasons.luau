local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

game:DefineFastInt("LuaLogoutReasonsThrottleHundrethsPercent", 0)

return {
	eventName = "LuaLogoutReasons",
	description = "Report Lua logout reasons to Points with document name \"lualogoutreasons\"",
	links = "https://roblox.atlassian.net/wiki/spaces/AUTH/pages/1972602346/Logout+telemetry+for+Universal+App",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("LuaLogoutReasonsThrottleHundrethsPercent"),
	lastUpdated = {
		23,
		2,
		16
	}
}
