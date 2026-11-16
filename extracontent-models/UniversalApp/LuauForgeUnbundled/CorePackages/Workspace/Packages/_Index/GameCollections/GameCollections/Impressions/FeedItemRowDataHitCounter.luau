local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/LoggingProtocol")

local FIntFeedItemRowDataCounterThrottle = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/FIntFeedItemRowDataCounterThrottle")

return {
	eventName = "feedItemRowDataHitCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = FIntFeedItemRowDataCounterThrottle,
	lastUpdated = { 24, 5, 29 },
	description = "Count the number of times feed item row data is accessible when game impression is sent"
}
