local Parent = script:FindFirstAncestor("GameCollections").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local FIntFeedItemRowDataCounterThrottle = require(script.Parent.FIntFeedItemRowDataCounterThrottle)

return {
	eventName = "feedItemRowDataMissingCounter",
	description = "Count the number of times feed item data is missing when game impression is sent",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = FIntFeedItemRowDataCounterThrottle,
	lastUpdated = {
		24,
		5,
		29
	}
}
