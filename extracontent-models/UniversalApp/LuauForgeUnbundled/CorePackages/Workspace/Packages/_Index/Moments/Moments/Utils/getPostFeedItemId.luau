require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function getPostFeedItemId(p2)
	if p2 == nil then
		return nil
	end

	local recommendationMetadata = p2.recommendationMetadata
	local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil

	if feedItemId == nil or feedItemId == "" then
		return nil
	end

	if p2.momentId == feedItemId then
		return feedItemId
	end

	return nil
end

return getPostFeedItemId
