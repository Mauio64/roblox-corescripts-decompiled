local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local networkRequests = scriptParent.networkRequests
local FFlagContentFeedEnableReactions = require(scriptParentParent.SharedFlags).FFlagContentFeedEnableReactions
local createAddReaction = require(networkRequests.createAddReaction)
local createCheckMomentsEligibility = require(networkRequests.createCheckMomentsEligibility)
local createDeletePost = require(networkRequests.createDeletePost)
local createGetPostsByCursor = require(networkRequests.createGetPostsByCursor)
local createGetPostsByPostId = require(networkRequests.createGetPostsByPostId)
local createGetPostsByUserId = require(networkRequests.createGetPostsByUserId)
local createGetThumbnailByAssetId = require(networkRequests.createGetThumbnailByAssetId)
local createRemoveReaction = require(networkRequests.createRemoveReaction)

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: FFlagContentFeedEnableReactions (copy), createAddReaction (copy), createCheckMomentsEligibility (copy), createDeletePost (copy), networkRequests (copy), createGetPostsByCursor (copy), createGetPostsByPostId (copy), createGetPostsByUserId (copy), createGetThumbnailByAssetId (copy), createRemoveReaction (copy)
	return {
		AddReaction = if not FFlagContentFeedEnableReactions then nil else createAddReaction(t1),
		CheckMomentsEligibility = createCheckMomentsEligibility(t1),
		DeletePost = createDeletePost(t1),
		GetActiveCategories = require(networkRequests.createGetActiveCategories)(t1),
		GetPostsByCursor = createGetPostsByCursor(t1),
		GetPostsByPostId = createGetPostsByPostId(t1),
		GetPostsByUserId = createGetPostsByUserId(t1),
		GetThumbnailByAssetId = createGetThumbnailByAssetId(t1),
		RemoveReaction = if not FFlagContentFeedEnableReactions then nil else createRemoveReaction(t1)
	}
end
