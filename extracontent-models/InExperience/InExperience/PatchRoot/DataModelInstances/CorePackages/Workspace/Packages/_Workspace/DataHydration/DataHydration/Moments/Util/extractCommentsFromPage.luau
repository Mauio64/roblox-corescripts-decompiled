local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.MomentsTypes)
local convertApiCommentToComment = require(DataHydration.Moments.Util.convertApiCommentToComment)

local function extractCommentsFromPage(p)
	local commentsFromPage = {}

	if type(p) ~= "table" or type(p.comments) ~= "table" then
		return commentsFromPage
	end

	for _, comment in p.comments do
		local v = convertApiCommentToComment(comment)

		if v ~= nil then
			commentsFromPage[v.commentId] = v
		end
	end

	return commentsFromPage
end

return extractCommentsFromPage
