local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local convertApiMomentComments = require(DataHydration.Moments.Util.convertApiMomentComments)

local function extractCommentsByFeedItemId(items)
	local commentsByFeedItemId = {}

	if items == nil then
		return commentsByFeedItemId
	end

	for _, item in items do
		local feedItemId = item.feedItemId

		if not (type(feedItemId) == "string" and feedItemId ~= "") then
			continue
		end

		local v = convertApiMomentComments(item.comments)

		if v ~= nil then
			commentsByFeedItemId[feedItemId] = v
		end
	end

	return commentsByFeedItemId
end

return extractCommentsByFeedItemId
