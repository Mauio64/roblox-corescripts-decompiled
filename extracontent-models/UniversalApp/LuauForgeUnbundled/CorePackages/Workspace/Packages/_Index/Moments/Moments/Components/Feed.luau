local module = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Feed")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/createFeedStore")
local feedTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/feedTelemetry")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/createRecommendationTelemetry")

return {
	Feed = module,
	createFeedStore = module3,
	createMockFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Sources/createMockFeedSource"),
	createSnapshotFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Sources/createSnapshotFeedSource"),
	createNoopTelemetry = feedTelemetry.createNoopTelemetry,
	createRecommendationTelemetry = module5,
	useFeed = FeedContext.useFeed
}
