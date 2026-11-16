local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local module2 = require("@luauforge/bundled/eDj")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local makeRecommendationAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeRecommendationAttribution")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")

return {
	{
		kind = "avatarMoment",
		getKey = function(p2)
			local feedItemId = p2.moment.recommendationMetadata.feedItemId

			if feedItemId == nil or feedItemId == "" then
				return p2.moment.momentId
			end

			return feedItemId
		end,
		getAttribution = function(p2)
			local moment = p2.moment

			if FFlagMomentsRecommendationContentType then
				return makeRecommendationAttribution(moment.recommendationMetadata, moment, "Avatar")
			end

			local recommendationMetadata = moment.recommendationMetadata
			local feedItemId = recommendationMetadata.feedItemId

			if feedItemId == nil or feedItemId == "" then
				return nil
			end

			return { itemId = feedItemId, tracingId = recommendationMetadata.tracingId }
		end,
		render = function(p2, p3)
			return React.createElement(module2, { index = p3, item = p2 })
		end
	}
}
