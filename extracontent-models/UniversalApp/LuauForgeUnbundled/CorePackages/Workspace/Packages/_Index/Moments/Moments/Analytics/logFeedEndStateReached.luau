local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Analytics
local eventNames = analytics.EventNames

local function logFeedEndStateReached(data)
	analytics.fireAnalyticsEvent(eventNames.FeedEndStateReached, {
		source = data.source,
		recommendationSource = data.recommendationSource,
		feedSourceId = data.feedSourceId,
		itemPosition = tostring(data.itemPosition)
	})
end

return logFeedEndStateReached
