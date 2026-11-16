require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local convertApiCommentToComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiCommentToComment")

local function extractCommentsFromPage(p2)
	local commentsFromPage = {}

	if type(p2) ~= "table" or type(p2.comments) ~= "table" then
		return commentsFromPage
	end

	for k, comment in p2.comments do
		local v5 = convertApiCommentToComment(comment)

		if v5 ~= nil then
			commentsFromPage[v5.commentId] = v5
		end
	end

	return commentsFromPage
end

return extractCommentsFromPage
