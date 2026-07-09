local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

game:DefineFastInt("SortDeeplinkFailureEventThrottleHundrethsPercent", 10000)

return {
	eventName = "SortDeeplinkFailedCounter",
	description = "Tracks failures to resolve sort deeplinks",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = game:GetFastInt("SortDeeplinkFailureEventThrottleHundrethsPercent"),
	lastUpdated = {
		24,
		10,
		18
	}
}
