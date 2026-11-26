local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local convertApiCommentToComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiCommentToComment")

local function commentPath(p2, p3)
	return `moment-comments-api/v1/moments/{p2}/comments/{p3}`
end

local function fetchMomentComment(p2, p3, p4)
	local v5, v6 = constructApiUrl(`moment-comments-api/v1/moments/{p2}/comments/{p3}`)

	return HttpClient.fetch({
		method = "GET",
		url = v5,
		headers = v6,
		analyticsKey = "moments.get-comment",
		network = p4,
		decode = function(p5)
			return convertApiCommentToComment(p5)
		end
	})
end

return fetchMomentComment
