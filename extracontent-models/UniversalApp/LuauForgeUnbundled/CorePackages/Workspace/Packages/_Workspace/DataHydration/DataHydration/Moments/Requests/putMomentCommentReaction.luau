local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local isCanonicalNonzeroUuid = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/isCanonicalNonzeroUuid")

local function reactionPath(p2, p3)
	return `moment-comments-api/v1/moments/{p2}/comments/{p3}/reactions`
end

local function putMomentCommentReaction(p2, p3, p4, p5, p6)
	assert(isCanonicalNonzeroUuid(p2), "putMomentCommentReaction: feedItemId must be a canonical nonzero UUID")
	assert(isCanonicalNonzeroUuid(p3), "putMomentCommentReaction: commentId must be a canonical nonzero UUID")
	assert(isCanonicalNonzeroUuid(p4), "putMomentCommentReaction: emoteId must be a canonical nonzero UUID")
	local v5, v6 = constructApiUrl(`moment-comments-api/v1/moments/{p2}/comments/{p3}/reactions`)
	return HttpClient.fetch({
		method = "PUT",
		url = v5,
		headers = v6,
		body = { reactionType = "thumbsup", emoteId = p4 },
		analyticsKey = "moments.put-comment-reaction",
		network = p5,
		retry = false,
		statusCodeActions = p6,
		decode = function(p7): nil
			return nil
		end
	})
end

return putMomentCommentReaction
