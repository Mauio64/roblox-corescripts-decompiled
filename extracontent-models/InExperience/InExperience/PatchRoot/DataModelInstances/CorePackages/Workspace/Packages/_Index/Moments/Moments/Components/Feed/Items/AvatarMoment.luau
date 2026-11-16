local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

local AvatarMomentContainer = require(script.AvatarMomentContainer)
require(Moments.Components.Feed.FeedTypes)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)

return {
	{
		kind = "avatarMoment",
		getKey = function(p)
			local feedItemId = p.moment.recommendationMetadata.feedItemId

			if feedItemId == nil or feedItemId == "" then
				return p.moment.momentId
			end

			return feedItemId
		end,
		getAttribution = function(p)
			local moment = p.moment

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
		render = function(p, p2: number)
			return React.createElement(AvatarMomentContainer, { index = p2, item = p })
		end
	}
}
