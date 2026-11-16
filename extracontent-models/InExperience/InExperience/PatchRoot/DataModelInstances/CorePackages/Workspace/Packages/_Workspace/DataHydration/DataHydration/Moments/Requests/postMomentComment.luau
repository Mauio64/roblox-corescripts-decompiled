local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local convertApiCommentToComment = require(DataHydration.Moments.Util.convertApiCommentToComment)

local function commentsPath(p: string) -- 1 equivalent call inferred from this helper
	return `moment-comments-api/v1/moments/{p}/comments`
end

local function postMomentComment(p: string, body, network, statusCodeActions)
	local url, headers = constructApiUrl(commentsPath(p)) -- inferred equivalent call

	return HttpClient.fetch({
		method = "POST",
		url = url,
		headers = headers,
		body = body,
		analyticsKey = "moments.post-comment",
		network = network,
		statusCodeActions = statusCodeActions,
		decode = function(p2)
			local v = convertApiCommentToComment(p2)
			assert(v ~= nil, "postMomentComment: response was not a Comment")
			return v
		end
	})
end

return postMomentComment
