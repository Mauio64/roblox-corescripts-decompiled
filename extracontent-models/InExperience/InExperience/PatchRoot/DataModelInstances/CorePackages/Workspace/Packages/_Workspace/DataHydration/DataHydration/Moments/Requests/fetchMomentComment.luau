local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local convertApiCommentToComment = require(DataHydration.Moments.Util.convertApiCommentToComment)

local function commentPath(p: string, p2: string) -- 1 equivalent call inferred from this helper
	return `moment-comments-api/v1/moments/{p}/comments/{p2}`
end

local function fetchMomentComment(p: string, p2: string, network)
	local url, headers = constructApiUrl(commentPath(p, p2)) -- inferred equivalent call

	return HttpClient.fetch({
		method = "GET",
		url = url,
		headers = headers,
		analyticsKey = "moments.get-comment",
		network = network,
		decode = function(p3)
			return convertApiCommentToComment(p3)
		end
	})
end

return fetchMomentComment
