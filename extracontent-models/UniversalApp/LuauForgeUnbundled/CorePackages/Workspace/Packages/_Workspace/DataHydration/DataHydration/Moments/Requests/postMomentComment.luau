local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local convertApiCommentToComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiCommentToComment")

local function commentsPath(p2)
	return `moment-comments-api/v1/moments/{p2}/comments`
end

local function postMomentComment(p2, p3, p4, p5)
	local v5, v6 = constructApiUrl(`moment-comments-api/v1/moments/{p2}/comments`)

	return HttpClient.fetch({
		method = "POST",
		url = v5,
		headers = v6,
		body = p3,
		analyticsKey = "moments.post-comment",
		network = p4,
		statusCodeActions = p5,
		decode = function(p6)
			local v7 = convertApiCommentToComment(p6)
			assert(v7 ~= nil, "postMomentComment: response was not a Comment")
			return v7
		end
	})
end

return postMomentComment
