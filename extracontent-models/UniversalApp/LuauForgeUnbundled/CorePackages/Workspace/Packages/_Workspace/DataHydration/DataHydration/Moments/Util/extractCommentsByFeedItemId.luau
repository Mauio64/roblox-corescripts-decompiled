require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local convertApiMomentComments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiMomentComments")

local function extractCommentsByFeedItemId(items)
	local commentsByFeedItemId = {}

	if items == nil then
		return commentsByFeedItemId
	end

	for k, item in items do
		local feedItemId = item.feedItemId

		if not (type(feedItemId) == "string" and feedItemId ~= "") then
			continue
		end

		local v5 = convertApiMomentComments(item.comments)

		if v5 ~= nil then
			commentsByFeedItemId[feedItemId] = v5
		end
	end

	return commentsByFeedItemId
end

return extractCommentsByFeedItemId
