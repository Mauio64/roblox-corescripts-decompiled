local parent = script:FindFirstAncestor("Moments").Parent

require(parent.MomentsTypes)

local function getPostFeedItemId(p)
	if p == nil then
		return nil
	end

	local recommendationMetadata = p.recommendationMetadata
	local feedItemId

	if recommendationMetadata ~= nil then
		feedItemId = recommendationMetadata.feedItemId
	end

	if feedItemId == nil or feedItemId == "" then
		return nil
	end

	return if p.momentId == feedItemId then feedItemId else nil
end

return getPostFeedItemId
