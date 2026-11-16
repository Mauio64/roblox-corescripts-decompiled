local parent = script:FindFirstAncestor("GameCollections").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local FIntFeedItemRowDataCounterThrottle = require(script.Parent.FIntFeedItemRowDataCounterThrottle)

return {
	eventName = "feedItemRowDataHitCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = FIntFeedItemRowDataCounterThrottle,
	lastUpdated = { 24, 5, 29 },
	description = "Count the number of times feed item row data is accessible when game impression is sent"
}
