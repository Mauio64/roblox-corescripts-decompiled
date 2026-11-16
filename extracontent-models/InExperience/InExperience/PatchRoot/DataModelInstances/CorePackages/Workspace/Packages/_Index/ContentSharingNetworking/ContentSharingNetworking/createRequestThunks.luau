local parent = script.Parent
local parent2 = parent.Parent
local networkRequests = parent.networkRequests

local SharedFlags = require(parent2.SharedFlags)
local FFlagContentFeedEnableReactions = SharedFlags.FFlagContentFeedEnableReactions

local createAddReaction = require(networkRequests.createAddReaction)
local createCheckMomentsEligibility = require(networkRequests.createCheckMomentsEligibility)
local createDeletePost = require(networkRequests.createDeletePost)
local createGetPostsByCursor = require(networkRequests.createGetPostsByCursor)
local createGetPostsByPostId = require(networkRequests.createGetPostsByPostId)
local createGetPostsByUserId = require(networkRequests.createGetPostsByUserId)
local createGetThumbnailByAssetId = require(networkRequests.createGetThumbnailByAssetId)
local createRemoveReaction = require(networkRequests.createRemoveReaction)

return function(p)
	local addReaction

	if FFlagContentFeedEnableReactions then
		addReaction = createAddReaction(p)
	end

	local v = {
		AddReaction = addReaction,
		CheckMomentsEligibility = createCheckMomentsEligibility(p),
		DeletePost = createDeletePost(p),
		GetActiveCategories = 0,
		GetPostsByCursor = 0,
		GetPostsByPostId = 0,
		GetPostsByUserId = 0,
		GetThumbnailByAssetId = 0,
		RemoveReaction = 0
	}
	local createGetActiveCategories = require(networkRequests.createGetActiveCategories)
	v.GetActiveCategories = createGetActiveCategories(p)
	v.GetPostsByCursor = createGetPostsByCursor(p)
	v.GetPostsByPostId = createGetPostsByPostId(p)
	v.GetPostsByUserId = createGetPostsByUserId(p)
	v.GetThumbnailByAssetId = createGetThumbnailByAssetId(p)
	local removeReaction

	if FFlagContentFeedEnableReactions then
		removeReaction = createRemoveReaction(p)
	end

	v.RemoveReaction = removeReaction
	return v
end
