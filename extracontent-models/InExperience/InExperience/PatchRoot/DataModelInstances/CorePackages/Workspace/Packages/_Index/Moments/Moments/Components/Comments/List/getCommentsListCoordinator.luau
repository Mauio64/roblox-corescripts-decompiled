local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsComments = require(parent.DataHydration.MomentsComments)
local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
local SharedFlags = require(parent.SharedFlags)
local MomentsGetMomentsReactionsStore = require(parent.DataHydration.MomentsGetMomentsReactionsStore)
local Signals = require(parent.Signals)

local GetCommentCollectionStore = require(Moments.Components.Comments.GetCommentCollectionStore)
local GetCommentSessionFiltersStore = require(Moments.Components.Comments.GetCommentSessionFiltersStore)
local GetCommentReactionsStore = require(Moments.Stores.GetCommentReactionsStore)
local createCommentsListCoordinator = require(script.Parent.createCommentsListCoordinator)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks

local function getCommentPostedCallback(p: string, p2: number)
	local getCommentsSheetStore = require(script.Parent.Parent.Sheet.getCommentsSheetStore)
	local recommendationSession = getCommentsSheetStore(false).getRecommendationSession(p, p2)

	if recommendationSession == nil then
		return nil
	end

	return recommendationSession.logComment
end

local function getPinnedCommentId(p: string, p2: number)
	local getCommentsSheetStore = require(script.Parent.Parent.Sheet.getCommentsSheetStore)
	local target = getCommentsSheetStore(false).getTarget(p, p2)
	return if target ~= nil then target.commentId else nil
end

local function getCommentDeletedCallback(p: string, p2: number)
	local getCommentsSheetStore = require(script.Parent.Parent.Sheet.getCommentsSheetStore)
	local recommendationSession = getCommentsSheetStore(false).getRecommendationSession(p, p2)

	if recommendationSession == nil then
		return nil
	end

	return recommendationSession.logCommentDelete
end

return Signals.createComputed(function(_)
	local commentsStore = MomentsGetMomentsCommentsStore(false)
	local v = {
		collectionStore = GetCommentCollectionStore(false),
		commentsStore = commentsStore,
		reactionStore = 0,
		catalogStore = 0,
		sessionFilters = 0,
		network = 0,
		getCommentPostedCallback = 0,
		getAnalyticsSession = 0,
		getCommentDeletedCallback = 0,
		getPinnedCommentId = 0
	}
	local reactionStore

	if FFlagMomentsComments then
		reactionStore = GetCommentReactionsStore(false)
	end

	v.reactionStore = reactionStore
	local catalogStore

	if FFlagMomentsComments then
		catalogStore = MomentsGetMomentsReactionsStore(false)
	end

	v.catalogStore = catalogStore
	v.sessionFilters = GetCommentSessionFiltersStore(false)
	v.network = MomentsComments.resolveCommentsNetwork(nil)
	local getCommentPostedCallback2

	if FFlagMomentsComments then
		getCommentPostedCallback2 = getCommentPostedCallback
	end

	v.getCommentPostedCallback = getCommentPostedCallback2
	v.getAnalyticsSession = FFlagMomentsComments and function(p, p2)
		local getCommentsSheetStore = require(script.Parent.Parent.Sheet.getCommentsSheetStore)
		return getCommentsSheetStore(false).getAnalyticsSession(p, p2)
	end or nil
	local getCommentDeletedCallback2

	if FFlagMomentsComments then
		getCommentDeletedCallback2 = getCommentDeletedCallback
	end

	v.getCommentDeletedCallback = getCommentDeletedCallback2
	local getPinnedCommentId2

	if FFlagMomentsCommentDeepLinks then
		getPinnedCommentId2 = getPinnedCommentId
	end

	v.getPinnedCommentId = getPinnedCommentId2
	return createCommentsListCoordinator(v)
end)
