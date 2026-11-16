local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local analytics = MomentsCommon.Analytics
local recommendationSource = MomentsCommon.Analytics.RecommendationSource

local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetPostAssetStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local createPendingFeedGetter = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createPendingFeedGetter")
local hydrateAvatarMomentFeedItems = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/hydrateAvatarMomentFeedItems")
local shouldShowMomentInFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/shouldShowMomentInFeed")
local reportUnavailableFeedItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/reportUnavailableFeedItem")
local GetReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetReactionsStore")
local GetShareCountsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore")
local GetDeletedMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeletedMomentsStore")
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments

local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore") else nil

local function createUserMomentsFeedSource(p2, options)
	local v6 = options or {}
	local v7 = if v6.userStore == nil then MomentsGetMomentsUserStore(false) else v6.userStore
	local v8

	if fFlagMomentsComments then
		v8 = v6.commentsStore

		if v8 == nil and v5 ~= nil then
			v8 = v5(false)
		end
	else
		v8 = nil
	end

	local initialIndex = v6.initialIndex

	local userMomentsFeedSource = {
		id = `profile:{p2}`,
		initialMomentId = 0,
		getPendingItems = 0,
		recommendationSource = 0,
		fetchAsync = 0
	}
	local v9 = if fFlagMomentsOptimisticProfilePending then v6.initialMomentId else nil
	userMomentsFeedSource.initialMomentId = v9

	local v10 = if fFlagMomentsOptimisticProfilePending then createPendingFeedGetter(p2, v7) else nil
	userMomentsFeedSource.getPendingItems = v10

	userMomentsFeedSource.recommendationSource = recommendationSource.Profile

	function userMomentsFeedSource.fetchAsync(p3)
		local v11 = if v8 ~= nil then v8.getOwnerGeneration(false) else nil

		local comments = nil
		local v12 = {}

		local flag = p3 == nil

		repeat
			local v13, v14 = v7.getUserMoments(p2, p3):await()

			if not v13 then
				error(v14)
			end

			if v14.commentsByFeedItemId ~= nil then
				comments = comments or {}

				for k, comment in v14.commentsByFeedItemId do
					comments[k] = comment
				end
			end

			GetReactionsStore(false).setBatchReactionCounts(v14.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v14.shareInfoByMomentId or {})
			local v15

			if fFlagMomentsRemoveDeletedFromProfile or fFlagMomentsOptimisticProfilePending then
				v15 = GetDeletedMomentsStore(false).getDeletedIds(false)
			end

			for k, moment in v14.moments do
				analytics.reportMomentsFeedItemsReceived(recommendationSource.Profile)
				local v16 = not (v15 == nil) and table.find(v15, moment.momentId) ~= nil
				local v17 = shouldShowMomentInFeed(moment)

				if v16 or not v17 then
					if v16 then
						analytics.reportMomentsFeedItemFiltered("deleted", recommendationSource.Profile)
					else
						reportUnavailableFeedItem(moment, recommendationSource.Profile)
					end
				else
					table.insert(v12, { kind = "moment", moment = moment })
				end
			end

			p3 = v14.nextCursor
			local v16

			if flag then
				v16 = not (initialIndex == nil or not (#v12 < initialIndex)) and p3 ~= nil
			else
				v16 = flag
			end
		until not v16

		if fFlagProfileRenderAvatarMoments then
			v12 = hydrateAvatarMomentFeedItems(v12, v6.postAssetStore or MomentsGetPostAssetStore(false))
		end

		local onAccepted

		if fFlagMomentsComments and v8 ~= nil and v11 ~= nil and comments ~= nil then
			local v13 = v8

			onAccepted = function()
				v13.upsertMomentComments(comments, v11)
			end
		end

		return { items = v12, nextCursor = p3, onAccepted = onAccepted }
	end

	return userMomentsFeedSource
end

return createUserMomentsFeedSource
