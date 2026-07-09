local Feed = require(script.Feed)
local FeedContext = require(script.FeedContext)

require(script.FeedTypes)

local createFeedStore = require(script.createFeedStore)
local feedTelemetry = require(script.feedTelemetry)
local createRecommendationTelemetry = require(script.createRecommendationTelemetry)
local createMockFeedSource = require(script.Sources.createMockFeedSource)
local createSnapshotFeedSource = require(script.Sources.createSnapshotFeedSource)

return {
	Feed = Feed,
	createFeedStore = createFeedStore,
	createMockFeedSource = createMockFeedSource,
	createSnapshotFeedSource = createSnapshotFeedSource,
	createNoopTelemetry = feedTelemetry.createNoopTelemetry,
	createRecommendationTelemetry = createRecommendationTelemetry,
	useFeed = FeedContext.useFeed
}
