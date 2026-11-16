local parent = script:FindFirstAncestor("Achievements").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

game:DefineFastInt("AchievementGrantedThrottleHundrethsPercent", 0)

return {
	eventName = "AchievementGranted",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:GetFastInt("AchievementGrantedThrottleHundrethsPercent"),
	lastUpdated = { 24, 7, 3 },
	description = "Report whenever an achievement is granted to Points with document name \"achievementgranted\""
}
