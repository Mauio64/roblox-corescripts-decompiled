require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Promise")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local analytics = MomentsCommon.Analytics
local recommendationSource = MomentsCommon.Analytics.RecommendationSource

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/SignalTracker")
local MomentsGetMomentsTrendingStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsTrendingStore")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetPostAssetStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local createPendingFeedGetter = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createPendingFeedGetter")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")
local fetchMomentsByIds = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/fetchMomentsByIds")
local hydrateAvatarMomentFeedItems = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/hydrateAvatarMomentFeedItems")
local shouldShowMomentInFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/shouldShowMomentInFeed")
local reportUnavailableFeedItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/reportUnavailableFeedItem")
local GetDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore/createDeepLinkStore")
local GetReactionsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetReactionsStore")
local GetShareCountsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore")
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsModeratedMomentPage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsModeratedMomentPage")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks

local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore") else nil

local momentStatus = MomentsTypes.Enums.MomentStatus

local function withCommentsSeeding(callback, p2, p3, p4)
	if p2 == nil or p3 == nil or p4 == nil then
		return callback
	end

	return function()
		if callback ~= nil then
			callback()
		end

		p2.upsertMomentComments(p4, p3)
	end
end

local function defaultFetchDeepLinkedMoments(p2, p3)
	return Promise.resolve():andThen(function()
		return fetchMomentsByIds({ p2 }, p3)
	end)
end

local function mergeCommentsByFeedItemId(options, items)
	if items == nil then
		return options
	end

	local result = options or {}

	for k, item in items do
		result[k] = item
	end

	return result
end

local function hasDeepLinkIdentity(p2, p3): boolean
	if p2.momentId == p3 then
		return true
	end

	local recommendationMetadata = p2.recommendationMetadata
	return recommendationMetadata ~= nil and recommendationMetadata.feedItemId == p3
end

local function findDeepLinkTarget(items, p2)
	for k, item in items do
		local v6

		if item.momentId == p2 then
			v6 = true
		else
			local recommendationMetadata = item.recommendationMetadata
			v6 = not (recommendationMetadata == nil) and recommendationMetadata.feedItemId == p2
		end

		if v6 then
			return item
		end
	end

	return nil
end

local function makeUnavailableMomentItem(deepLinkedMomentId, moments, moments2)
	local item

	for k, item2 in moments do
		local v7

		if item2.momentId == deepLinkedMomentId then
			v7 = true
		else
			local recommendationMetadata = item2.recommendationMetadata

			if recommendationMetadata == nil then
				v7 = false
			else
				v7 = recommendationMetadata.feedItemId == deepLinkedMomentId
			end
		end

		if v7 then
			item = item2
			break
		end
	end

	local v7

	if item then
		v7 = item
	else
		for k, item2 in moments2 do
			local v9

			if item2.momentId == deepLinkedMomentId then
				v9 = true
			else
				local recommendationMetadata = item2.recommendationMetadata

				if recommendationMetadata == nil then
					v9 = false
				else
					v9 = recommendationMetadata.feedItemId == deepLinkedMomentId
				end
			end

			if v9 then
				v7 = item2
				break
			end
		end
	end

	return {
		kind = "unavailableMoment",
		targetId = deepLinkedMomentId,
		isModerated = v7 ~= nil and v7.status ~= momentStatus.Deleted and v7.isModerated == true
	}
end

local function loadDeepLinkedMomentsForUnavailableDialog(fetchDeepLinkedMoments, deepLinkedMomentId, deepLinkedMomentTargetIdType, deepLinkFetchTimeoutSeconds)
	local v6 = {
		fetchDeepLinkedMoments(deepLinkedMomentId, deepLinkedMomentTargetIdType):catch(function(): nil
			return nil
		end),
		(Promise.delay(deepLinkFetchTimeoutSeconds):andThen(function(): nil
			return nil
		end))
	}
	local v7, v8 = Promise.race(v6):await()

	if v7 and type(v8) == "table" then
		return v8
	end

	return nil
end

local function createMomentsFeedSource(callback, options)
	local v6 = options or {}
	local v7 = if v6.trendingStore == nil then MomentsGetMomentsTrendingStore(false) else v6.trendingStore
	local v8

	if fFlagMomentsComments then
		v8 = v6.commentsStore

		if v8 == nil and v5 ~= nil then
			v8 = v5(false)
		end
	else
		v8 = nil
	end

	local deepLinkStore = v6.deepLinkStore or GetDeepLinkStore()
	local fetchDeepLinkedMoments = v6.fetchDeepLinkedMoments or defaultFetchDeepLinkedMoments
	local deepLinkFetchTimeoutSeconds = v6.deepLinkFetchTimeoutSeconds or 20

	local nextCursor = nil
	local v9 = nil

	if fFlagMomentsOptimisticProfilePending then
		local localUserId = v6.localUserId or getLocalUserId()

		if localUserId ~= nil then
			v9 = createPendingFeedGetter(localUserId, v6.userStore or MomentsGetMomentsUserStore(false))
		end
	end

	return {
		id = "trending",
		getPendingItems = v9,
		recommendationSource = recommendationSource.Trending,
		fetchAsync = function(p2)
			local v10 = if v8 ~= nil then v8.getOwnerGeneration(false) else nil
			local v11 = p2 or nextCursor
			local signalTracker = v6.signalTracker
			local v12 = if signalTracker then signalTracker:getSignalsPayload() else nil
			local v13, v14 = v7.getTrending(callback(false), v11, v12):await()

			if not v13 then
				error(v14)
			end

			local commentsByFeedItemId = v14.commentsByFeedItemId
			local comments

			if commentsByFeedItemId == nil then
				comments = nil
			else
				comments = {}

				for k, comment in commentsByFeedItemId do
					comments[k] = comment
				end
			end

			nextCursor = v14.nextCursor or nextCursor

			if p2 == nil then
				GetReactionsStore(false).clear()
				GetShareCountsStore(false).clear()
			end

			GetReactionsStore(false).setBatchReactionCounts(v14.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v14.shareInfoByMomentId or {})

			local v15 = {}
			local fn
			local momentId = nil
			local v16 = nil

			if p2 == nil then
				local deepLinkedMomentId = deepLinkStore.getDeepLinkedMomentId(false)
				local deepLinkedMomentTargetIdType = deepLinkStore.getDeepLinkedMomentTargetIdType(false)

				if deepLinkedMomentId ~= nil then
					local v17 = {}
					local v18 = nil

					for k, moment in v14.moments do
						v17[moment.momentId] = true

						if v18 ~= nil then
							continue
						end

						local v19

						if moment.momentId == deepLinkedMomentId then
							v19 = true
						else
							local recommendationMetadata = moment.recommendationMetadata

							if recommendationMetadata == nil then
								v19 = false
							else
								v19 = recommendationMetadata.feedItemId == deepLinkedMomentId
							end
						end

						if v19 then
							v18 = moment
						end
					end

					local v19 = false
					local v20 = false

					local feedItemId = nil
					local v21 = not (v18 == nil) and shouldShowMomentInFeed(v18)

					if v21 then
						table.insert(v15, { kind = "moment", moment = v18 })
						momentId = v18.momentId
						v19 = true

						if fFlagMomentsCommentDeepLinks then
							feedItemId = v18.recommendationMetadata.feedItemId
						end
					else
						local v22 = loadDeepLinkedMomentsForUnavailableDialog(
							fetchDeepLinkedMoments,
							deepLinkedMomentId,
							deepLinkedMomentTargetIdType,
							deepLinkFetchTimeoutSeconds
						)

						if v22 ~= nil then
							local commentsByFeedItemId2 = v22.commentsByFeedItemId

							if commentsByFeedItemId2 ~= nil then
								comments = comments or {}

								for k, comment in commentsByFeedItemId2 do
									comments[k] = comment
								end
							end

							if v22.reactionsByMomentId then
								GetReactionsStore(false).setBatchReactionCounts(v22.reactionsByMomentId)
							end

							if v22.shareInfoByMomentId then
								GetShareCountsStore(false).setBatchShareCounts(v22.shareInfoByMomentId)
							end

							for k, moment in v22.moments do
								local v23

								if moment.momentId == deepLinkedMomentId then
									v23 = true
								else
									local recommendationMetadata = moment.recommendationMetadata

									if recommendationMetadata == nil then
										v23 = false
									else
										v23 = recommendationMetadata.feedItemId == deepLinkedMomentId
									end
								end

								if not (shouldShowMomentInFeed(moment) and v23) then
									continue
								end

								table.insert(v15, { kind = "moment", moment = moment })
								v19 = true

								if fFlagMomentsCommentDeepLinks then
									feedItemId = moment.recommendationMetadata.feedItemId
								end
							end

							v20 = not v19

							if FFlagMomentsModeratedMomentPage and v20 then
								table.insert(
									v15,
									makeUnavailableMomentItem(deepLinkedMomentId, v22.moments, v14.moments)
								)
							end
						end
					end

					if v19 or v20 then
						local v22 = v20 and not FFlagMomentsModeratedMomentPage

						fn = function()
							if deepLinkStore.getDeepLinkedMomentId(false) == deepLinkedMomentId then
								deepLinkStore.setDeepLinkedMomentId(nil)

								if fFlagMomentsCommentDeepLinks then
									deepLinkStore.resolvePendingCommentsTarget(
										deepLinkedMomentId,
										feedItemId
									)
								end

								if v22 and v6.onDeepLinkedMomentUnavailable ~= nil then
									v6.onDeepLinkedMomentUnavailable()
								end
							end
						end
					end
				end
			end

			local v17

			if fFlagMomentsComments then
				local v18 = v8
				v17 = v18 ~= nil and v10 ~= nil and comments ~= nil and function()
					if fn ~= nil then
						fn()
					end

					v18.upsertMomentComments(comments, v10)
				end or fn
			else
				v17 = fn
			end

			local v18 = v15[1]

			if fFlagMomentsOptimisticProfilePending and p2 == nil and v18 ~= nil then
				if v18.kind == "moment" then
					v16 = v18.moment.momentId
				elseif v18.kind == "unavailableMoment" then
					v16 = v18.targetId
				end
			end

			for k, moment in v14.moments do
				analytics.reportMomentsFeedItemsReceived(recommendationSource.Trending)
				local v19 = not (momentId == nil) and moment.momentId == momentId

				if v19 then
					continue
				end

				if shouldShowMomentInFeed(moment) then
					table.insert(v15, { kind = "moment", moment = moment })
				else
					reportUnavailableFeedItem(moment, recommendationSource.Trending)
				end
			end

			if fFlagMomentsRenderAvatarPostsInFeed then
				v15 = hydrateAvatarMomentFeedItems(v15, v6.postAssetStore or MomentsGetPostAssetStore(false))
			end

			return {
				items = v15,
				initialMomentId = v16,
				nextCursor = v14.nextCursor,
				onAccepted = v17
			}
		end
	}
end

return createMomentsFeedSource
