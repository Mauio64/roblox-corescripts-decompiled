local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LoggingProtocol")

game:DefineFastInt("LuaAppChallengeDeviceAccessEventThrottlingPercent", 10000)

return {
	eventName = "accountSecurityChallengeDeviceAccessTokenEvent",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("LuaAppChallengeDeviceAccessEventThrottlingPercent"),
	lastUpdated = { 24, 1, 22 },
	description = "Tracks lifecycle events for the Device Access GCS challenge",
	links = "https://roblox.atlassian.net/wiki/spaces/BaS/pages/2184872709/Bypassing+Challenges+for+Xbox+PS+Quest+etc+Requests#Event-Tracking"
}
