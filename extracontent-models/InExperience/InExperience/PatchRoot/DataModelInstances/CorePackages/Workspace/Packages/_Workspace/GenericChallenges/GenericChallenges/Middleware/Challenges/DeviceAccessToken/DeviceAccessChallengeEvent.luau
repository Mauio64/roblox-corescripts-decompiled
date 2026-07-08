local Parent = script:FindFirstAncestor("GenericChallenges").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

game:DefineFastInt("LuaAppChallengeDeviceAccessEventThrottlingPercent", 10000)

return {
	eventName = "accountSecurityChallengeDeviceAccessTokenEvent",
	description = "Tracks lifecycle events for the Device Access GCS challenge",
	links = "https://roblox.atlassian.net/wiki/spaces/BaS/pages/2184872709/Bypassing+Challenges+for+Xbox+PS+Quest+etc+Requests#Event-Tracking",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("LuaAppChallengeDeviceAccessEventThrottlingPercent"),
	lastUpdated = {
		24,
		1,
		22
	}
}
