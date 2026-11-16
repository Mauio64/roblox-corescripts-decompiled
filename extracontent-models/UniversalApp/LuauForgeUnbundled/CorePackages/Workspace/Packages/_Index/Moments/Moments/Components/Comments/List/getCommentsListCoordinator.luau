local MomentsComments = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsComments")
local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local MomentsGetMomentsReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsReactionsStore")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local GetCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore")
local GetCommentSessionFiltersStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentSessionFiltersStore")
local GetCommentReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetCommentReactionsStore")
local createCommentsListCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/createCommentsListCoordinator")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks

local function getCommentPostedCallback(p2, p3)
	local recommendationSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")(false).getRecommendationSession(p2, p3)

	if recommendationSession == nil then
		return nil
	end

	return recommendationSession.logComment
end

local function getPinnedCommentId(p2, p3)
	local target = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")(false).getTarget(p2, p3)

	if target == nil then
		return nil
	end

	return target.commentId
end

local function getCommentDeletedCallback(p2, p3)
	local recommendationSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")(false).getRecommendationSession(p2, p3)

	if recommendationSession == nil then
		return nil
	end

	return recommendationSession.logCommentDelete
end

return Signals.createComputed(function(p2)
	local v5 = MomentsGetMomentsCommentsStore(false)
	local v7 = {
		collectionStore = GetCommentCollectionStore(false),
		commentsStore = v5,
		reactionStore = 0,
		catalogStore = 0,
		sessionFilters = 0,
		network = 0,
		getCommentPostedCallback = 0,
		getAnalyticsSession = 0,
		getCommentDeletedCallback = 0,
		getPinnedCommentId = 0
	}

	local v8 = if fFlagMomentsComments then GetCommentReactionsStore(false) else nil
	v7.reactionStore = v8
	local v9 = if fFlagMomentsComments then MomentsGetMomentsReactionsStore(false) else nil
	v7.catalogStore = v9
	v7.sessionFilters = GetCommentSessionFiltersStore(false)
	v7.network = MomentsComments.resolveCommentsNetwork(nil)
	v7.getCommentPostedCallback = if fFlagMomentsComments then getCommentPostedCallback else nil
	v7.getAnalyticsSession = fFlagMomentsComments and function(p3, p4)
		return require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")(false).getAnalyticsSession(p3, p4)
	end or nil

	v7.getCommentDeletedCallback = if fFlagMomentsComments then getCommentDeletedCallback else nil
	v7.getPinnedCommentId = if fFlagMomentsCommentDeepLinks then getPinnedCommentId else nil
	return createCommentsListCoordinator(v7)
end)
