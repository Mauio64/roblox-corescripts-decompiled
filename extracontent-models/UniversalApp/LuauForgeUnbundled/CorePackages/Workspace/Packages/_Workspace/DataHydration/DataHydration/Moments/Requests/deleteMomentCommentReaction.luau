local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local constructApiUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/constructApiUrl")
local isCanonicalNonzeroUuid = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/isCanonicalNonzeroUuid")

local function reactionPath(p2, p3)
	return `moment-comments-api/v1/moments/{p2}/comments/{p3}/reactions`
end

local function deleteMomentCommentReaction(p2, p3, p4, p5, p6)
	assert(isCanonicalNonzeroUuid(p2), "deleteMomentCommentReaction: feedItemId must be a canonical nonzero UUID")

	assert(isCanonicalNonzeroUuid(p3), "deleteMomentCommentReaction: commentId must be a canonical nonzero UUID")
	assert(isCanonicalNonzeroUuid(p4), "deleteMomentCommentReaction: emoteId must be a canonical nonzero UUID")
	local v5, v6 = constructApiUrl(`moment-comments-api/v1/moments/{p2}/comments/{p3}/reactions`)
	return HttpClient.fetch({
		method = "DELETE",
		url = v5,
		headers = v6,
		body = { reactionType = "thumbsup", emoteId = p4 },
		analyticsKey = "moments.delete-comment-reaction",
		network = p5,
		retry = false,
		statusCodeActions = p6,
		decode = function(p7): nil
			return nil
		end
	})
end

return deleteMomentCommentReaction
