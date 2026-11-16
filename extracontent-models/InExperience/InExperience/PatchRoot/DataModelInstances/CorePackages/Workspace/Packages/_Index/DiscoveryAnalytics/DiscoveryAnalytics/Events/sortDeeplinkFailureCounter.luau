local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

game:DefineFastInt("SortDeeplinkFailureEventThrottleHundrethsPercent", 10000)

return {
	eventName = "SortDeeplinkFailedCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = game:GetFastInt("SortDeeplinkFailureEventThrottleHundrethsPercent"),
	lastUpdated = { 24, 10, 18 },
	description = "Tracks failures to resolve sort deeplinks"
}
