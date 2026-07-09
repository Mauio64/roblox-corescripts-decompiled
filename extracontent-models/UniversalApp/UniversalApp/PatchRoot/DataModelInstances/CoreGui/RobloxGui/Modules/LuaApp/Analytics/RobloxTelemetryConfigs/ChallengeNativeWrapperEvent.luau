local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

game:DefineFastInt("LuaAppChallengeNativeWrapperEventThrottleHundredthsPercent", 10000)

return {
	eventName = "accountSecurityChallengeNativeWrapperEvent",
	description = "Tracks lifecycle events for Lua GCS challenges",
	links = "https://roblox.atlassian.net/wiki/spaces/BaS/pages/2184872709/Bypassing+Challenges+for+Xbox+PS+Quest+etc+Requests#Event-Tracking",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("LuaAppChallengeNativeWrapperEventThrottleHundredthsPercent"),
	lastUpdated = {
		24,
		4,
		17
	}
}
