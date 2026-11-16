local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames

local function logFeedEndStateReached(data)
	Analytics.fireAnalyticsEvent(EventNames.FeedEndStateReached, {
		source = data.source,
		recommendationSource = data.recommendationSource,
		feedSourceId = data.feedSourceId,
		itemPosition = tostring(data.itemPosition)
	})
end

return logFeedEndStateReached
