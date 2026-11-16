local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local constructApiUrl = require(DataHydration.Moments.Util.constructApiUrl)
local isCanonicalNonzeroUuid = require(DataHydration.Moments.Util.isCanonicalNonzeroUuid)

local function reactionPath(p: string, p2: string) -- 1 equivalent call inferred from this helper
	return `moment-comments-api/v1/moments/{p}/comments/{p2}/reactions`
end

local function deleteMomentCommentReaction(p: string, p2: string, emoteId: string, network, statusCodeActions)
	assert(isCanonicalNonzeroUuid(p), "deleteMomentCommentReaction: feedItemId must be a canonical nonzero UUID")

	assert(isCanonicalNonzeroUuid(p2), "deleteMomentCommentReaction: commentId must be a canonical nonzero UUID")
	assert(isCanonicalNonzeroUuid(emoteId), "deleteMomentCommentReaction: emoteId must be a canonical nonzero UUID")

	local url, headers = constructApiUrl(reactionPath(p, p2)) -- inferred equivalent call
	return HttpClient.fetch({
		method = "DELETE",
		url = url,
		headers = headers,
		body = { reactionType = "thumbsup", emoteId = emoteId },
		analyticsKey = "moments.delete-comment-reaction",
		network = network,
		retry = false,
		statusCodeActions = statusCodeActions,
		decode = function(_): nil
			return nil
		end
	})
end

return deleteMomentCommentReaction
