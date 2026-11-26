local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local analytics = MomentsCommon.Analytics
local recommendationSource = MomentsCommon.Analytics.RecommendationSource

local MomentsGetMomentsFollowingStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsFollowingStore")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetPostAssetStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local hydrateAvatarMomentFeedItems = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/hydrateAvatarMomentFeedItems")
local shouldShowMomentInFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/shouldShowMomentInFeed")
local reportUnavailableFeedItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/reportUnavailableFeedItem")
local GetReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetReactionsStore")
local GetShareCountsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore") else nil

local function createFollowingFeedSource(options)
	local v6 = options or {}
	local v7 = if v6.followingStore == nil then MomentsGetMomentsFollowingStore(false) else v6.followingStore
	local v8

	if fFlagMomentsComments then
		v8 = v6.commentsStore

		if v8 == nil and v5 ~= nil then
			v8 = v5(false)
		end
	else
		v8 = nil
	end

	return {
		id = "following",
		recommendationSource = recommendationSource.Following,
		endsWithCaughtUp = true,
		fetchAsync = function(p2)
			local v9 = if v8 ~= nil then v8.getOwnerGeneration(false) else nil

			local v10, v11 = v7.getFollowing(p2):await()

			if not v10 then
				error(v11)
			end

			GetReactionsStore(false).setBatchReactionCounts(v11.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v11.shareInfoByMomentId or {})

			local v12 = {}

			for k, moment in v11.moments do
				analytics.reportMomentsFeedItemsReceived(recommendationSource.Following)

				if shouldShowMomentInFeed(moment) then
					table.insert(v12, { kind = "moment", moment = moment })
				else
					reportUnavailableFeedItem(moment, recommendationSource.Following)
				end
			end

			if fFlagMomentsRenderAvatarPostsInFeed then
				v12 = hydrateAvatarMomentFeedItems(v12, v6.postAssetStore or MomentsGetPostAssetStore(false))
			end

			local commentsByFeedItemId = v11.commentsByFeedItemId
			local onAccepted

			if fFlagMomentsComments and v8 ~= nil and v9 ~= nil and commentsByFeedItemId ~= nil then
				local v13 = v8

				onAccepted = function()
					v13.upsertMomentComments(commentsByFeedItemId, v9)
				end
			end

			return { items = v12, nextCursor = v11.nextCursor, onAccepted = onAccepted }
		end
	}
end

return createFollowingFeedSource
