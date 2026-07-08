local Constants = require(script.Constants)
local Enums = require(script.Enums)
local Feed = require(script.Components.Feed)
local MomentItem = require(script.Components.Feed.Items.Moment.MomentItem)
local MomentsTabEntry = require(script.MomentsTabEntry)
local MomentsFeedSurface = require(script.Components.MomentsFeedSurface)
local MomentsBackHeader = require(script.Components.MomentsBackHeader)
local MomentsHostShell = require(script.Components.MomentsHostShell)
local MomentsImmersivePresentation = require(script.Components.MomentsImmersivePresentation)

return {
	["jest.config"] = script["jest.config"],
	["jest.main.config"] = script["jest.main.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"],
	Constants = Constants,
	Enums = Enums,
	Feed = Feed.Feed,
	createFeedStore = Feed.createFeedStore,
	createMockFeedSource = Feed.createMockFeedSource,
	createSnapshotFeedSource = Feed.createSnapshotFeedSource,
	useFeed = Feed.useFeed,
	MomentItem = MomentItem,
	MomentsTabEntry = MomentsTabEntry,
	MomentsFeedSurface = MomentsFeedSurface,
	MomentsBackHeader = MomentsBackHeader,
	MomentsHostShell = MomentsHostShell,
	MomentsImmersivePresentation = MomentsImmersivePresentation
}
