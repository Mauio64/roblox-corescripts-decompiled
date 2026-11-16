local parent = script:FindFirstAncestor("IAPExperience").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

game:DefineFastInt("InGameRobuxUpsellEventThrottleHundredthsPercent", 0)

return {
	eventName = "InGameRobuxUpsellEvent",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("InGameRobuxUpsellEventThrottleHundredthsPercent"),
	lastUpdated = { 2024, 8, 22 },
	description = "Data points on all InGameRobuxUpsell events.",
	links = "https://roblox.atlassian.net/wiki/spaces/PAY/pages/1823605171/Robux+Upsell+InGame"
}
