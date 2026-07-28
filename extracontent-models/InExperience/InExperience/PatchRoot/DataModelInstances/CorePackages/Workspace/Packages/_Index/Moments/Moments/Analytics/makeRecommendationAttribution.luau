local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.MomentsTypes)
require(Moments.Components.Feed.FeedTypes)

local function makeRecommendationAttribution(p1) -- line: 28
	if p1 == nil then
		return nil
	end

	local feedItemId = p1.feedItemId

	if feedItemId == nil or feedItemId == "" then
		return nil
	end

	return {
		itemId = feedItemId,
		tracingId = p1.tracingId
	}
end

return makeRecommendationAttribution
