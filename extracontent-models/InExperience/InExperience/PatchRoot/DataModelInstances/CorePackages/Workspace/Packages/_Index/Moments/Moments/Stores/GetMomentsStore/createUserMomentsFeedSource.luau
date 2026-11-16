local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)

require(Moments.Components.Feed)
local Analytics = MomentsCommon.Analytics
local RecommendationSource = MomentsCommon.Analytics.RecommendationSource

local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)
require(parent.DataHydration.MomentsStoreTypes)
local createPendingFeedGetter = require(script.Parent.createPendingFeedGetter)
local hydrateAvatarMomentFeedItems = require(script.Parent.hydrateAvatarMomentFeedItems)
local shouldShowMomentInFeed = require(script.Parent.shouldShowMomentInFeed)
local reportUnavailableFeedItem = require(script.Parent.reportUnavailableFeedItem)
local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetDeletedMomentsStore = require(Moments.Stores.GetDeletedMomentsStore)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local MomentsGetMomentsCommentsStore

if FFlagMomentsComments then
	MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
else
	MomentsGetMomentsCommentsStore = nil
end

local function createUserMomentsFeedSource(p: number, options)
	local v = options or {}
	local v2

	if v.userStore == nil then
		v2 = MomentsGetMomentsUserStore(false)
	else
		v2 = v.userStore
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

	local initialIndex = v.initialIndex

	local userMomentsFeedSource = {
		id = `profile:{p}`,
		initialMomentId = 0,
		getPendingItems = 0,
		recommendationSource = 0,
		fetchAsync = 0
	}
	local initialMomentId

	if FFlagMomentsOptimisticProfilePending then
		initialMomentId = v.initialMomentId
	end

	userMomentsFeedSource.initialMomentId = initialMomentId
	local getPendingItems

	if FFlagMomentsOptimisticProfilePending then
		getPendingItems = createPendingFeedGetter(p, v2)
	end

	userMomentsFeedSource.getPendingItems = getPendingItems

	userMomentsFeedSource.recommendationSource = RecommendationSource.Profile

	function userMomentsFeedSource.fetchAsync(nextCursor)
		local v4

		if v3 == nil then
			v4 = nil
		else
			v4 = v3.getOwnerGeneration(false)
		end

		local comments = nil
		local items = {}

		local flag = nextCursor == nil

		repeat
			local v5, v6 = v2.getUserMoments(p, nextCursor):await()

			if not v5 then
				error(v6)
			end

			if v6.commentsByFeedItemId ~= nil then
				comments = comments or {}

				for k, comment in v6.commentsByFeedItemId do
					comments[k] = comment
				end
			end

			GetReactionsStore(false).setBatchReactionCounts(v6.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v6.shareInfoByMomentId or {})
			local v7

			if FFlagMomentsRemoveDeletedFromProfile or FFlagMomentsOptimisticProfilePending then
				v7 = GetDeletedMomentsStore(false).getDeletedIds(false)
			end

			for _, moment in v6.moments do
				Analytics.reportMomentsFeedItemsReceived(RecommendationSource.Profile)
				local v8

				if v7 == nil then
					v8 = false
				else
					v8 = table.find(v7, moment.momentId) ~= nil
				end

				local v9 = shouldShowMomentInFeed(moment)

				if v8 or not v9 then
					if v8 then
						Analytics.reportMomentsFeedItemFiltered("deleted", RecommendationSource.Profile)
					else
						reportUnavailableFeedItem(moment, RecommendationSource.Profile)
					end
				else
					table.insert(items, { kind = "moment", moment = moment })
				end
			end

			nextCursor = v6.nextCursor
			local v8

			if flag then
				if initialIndex == nil or not (#items < initialIndex) then
					v8 = false
				else
					v8 = nextCursor ~= nil
				end
			else
				v8 = flag
			end
		until not v8

		if FFlagProfileRenderAvatarMoments then
			items = hydrateAvatarMomentFeedItems(items, v.postAssetStore or MomentsGetPostAssetStore(false))
		end

		local onAccepted

		if FFlagMomentsComments and v3 ~= nil and v4 ~= nil and comments ~= nil then
			local v5 = v3

			onAccepted = function()
				v5.upsertMomentComments(comments, v4)
			end
		end

		return { items = items, nextCursor = nextCursor, onAccepted = onAccepted }
	end

	return userMomentsFeedSource
end

return createUserMomentsFeedSource
