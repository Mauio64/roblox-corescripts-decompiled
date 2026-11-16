local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)

require(Moments.Components.Feed)
local Analytics = MomentsCommon.Analytics
local RecommendationSource = MomentsCommon.Analytics.RecommendationSource

local MomentsGetMomentsFollowingStore = require(parent.DataHydration.MomentsGetMomentsFollowingStore)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)
require(parent.DataHydration.MomentsStoreTypes)
local hydrateAvatarMomentFeedItems = require(script.Parent.hydrateAvatarMomentFeedItems)
local shouldShowMomentInFeed = require(script.Parent.shouldShowMomentInFeed)
local reportUnavailableFeedItem = require(script.Parent.reportUnavailableFeedItem)
local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local MomentsGetMomentsCommentsStore

if FFlagMomentsComments then
	MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
else
	MomentsGetMomentsCommentsStore = nil
end

local function createFollowingFeedSource(options)
	local v = options or {}
	local v2

	if v.followingStore == nil then
		v2 = MomentsGetMomentsFollowingStore(false)
	else
		v2 = v.followingStore
	end

	local v3

	if FFlagMomentsComments then
		v3 = v.commentsStore

		if v3 == nil and MomentsGetMomentsCommentsStore ~= nil then
			v3 = MomentsGetMomentsCommentsStore(false)
		end
	else
		v3 = nil
	end

	return {
		id = "following",
		recommendationSource = RecommendationSource.Following,
		endsWithCaughtUp = true,
		fetchAsync = function(p)
			local v4

			if v3 == nil then
				v4 = nil
			else
				v4 = v3.getOwnerGeneration(false)
			end

			local v5, v6 = v2.getFollowing(p):await()

			if not v5 then
				error(v6)
			end

			GetReactionsStore(false).setBatchReactionCounts(v6.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v6.shareInfoByMomentId or {})

			local items = {}

			for _, moment in v6.moments do
				Analytics.reportMomentsFeedItemsReceived(RecommendationSource.Following)

				if shouldShowMomentInFeed(moment) then
					table.insert(items, { kind = "moment", moment = moment })
				else
					reportUnavailableFeedItem(moment, RecommendationSource.Following)
				end
			end

			if FFlagMomentsRenderAvatarPostsInFeed then
				items = hydrateAvatarMomentFeedItems(items, v.postAssetStore or MomentsGetPostAssetStore(false))
			end

			local commentsByFeedItemId = v6.commentsByFeedItemId
			local onAccepted

			if FFlagMomentsComments and v3 ~= nil and v4 ~= nil and commentsByFeedItemId ~= nil then
				local v7 = v3

				onAccepted = function()
					v7.upsertMomentComments(commentsByFeedItemId, v4)
				end
			end

			return { items = items, nextCursor = v6.nextCursor, onAccepted = onAccepted }
		end
	}
end

return createFollowingFeedSource
