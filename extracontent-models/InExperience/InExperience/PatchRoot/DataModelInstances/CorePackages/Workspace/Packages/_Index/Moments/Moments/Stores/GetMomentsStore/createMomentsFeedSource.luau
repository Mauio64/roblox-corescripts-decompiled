local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.Signals)
local Promise = require(parent.Promise)
local MomentsCommon = require(parent.MomentsCommon)
local MomentsTypes = require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)

require(Moments.Components.Feed)
local Analytics = MomentsCommon.Analytics
local RecommendationSource = MomentsCommon.Analytics.RecommendationSource

require(Moments.SignalTracker)
local MomentsGetMomentsTrendingStore = require(parent.DataHydration.MomentsGetMomentsTrendingStore)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)
require(parent.DataHydration.MomentsStoreTypes)
local createPendingFeedGetter = require(script.Parent.createPendingFeedGetter)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)
local getLocalUserId = require(Moments.Utils.getLocalUserId)
local fetchMomentsByIds = require(script.Parent.fetchMomentsByIds)
local hydrateAvatarMomentFeedItems = require(script.Parent.hydrateAvatarMomentFeedItems)
local shouldShowMomentInFeed = require(script.Parent.shouldShowMomentInFeed)
local reportUnavailableFeedItem = require(script.Parent.reportUnavailableFeedItem)
local GetDeepLinkStore = require(Moments.Stores.GetDeepLinkStore)
require(Moments.Stores.GetDeepLinkStore.createDeepLinkStore)
local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsModeratedMomentPage = require(Moments.Flags.FFlagMomentsModeratedMomentPage)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local FFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks
local MomentsGetMomentsCommentsStore

if FFlagMomentsComments then
	MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
else
	MomentsGetMomentsCommentsStore = nil
end

local MomentStatus = MomentsTypes.Enums.MomentStatus

local function withCommentsSeeding(fn, p, p2: number?, comments) -- 1 equivalent call inferred from this helper
	if p == nil or p2 == nil or comments == nil then
		return fn
	end

	return function()
		if fn ~= nil then
			fn()
		end

		p.upsertMomentComments(comments, p2)
	end
end

local function defaultFetchDeepLinkedMoments(p: string, p2: string?)
	return Promise.resolve():andThen(function()
		return fetchMomentsByIds({ p }, p2)
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

local function hasDeepLinkIdentity(p, p2: string): boolean -- 4 equivalent calls inferred from this helper
	if p.momentId == p2 then
		return true
	end

	local recommendationMetadata = p.recommendationMetadata
	return recommendationMetadata ~= nil and recommendationMetadata.feedItemId == p2
end

local function findDeepLinkTarget(items, p: string) -- 1 equivalent call inferred from this helper
	for _, item in items do
		if hasDeepLinkIdentity(item, p) then -- inferred equivalent call
			return item
		end
	end

	return nil
end

local function makeUnavailableMomentItem(deepLinkedMomentId: string, moments, moments2)
	local deepLinkTarget = findDeepLinkTarget(moments, deepLinkedMomentId) -- inferred equivalent call
	local v

	if deepLinkTarget then
		v = deepLinkTarget
	else
		for _, deepLinkTarget2 in moments2 do
			if hasDeepLinkIdentity(deepLinkTarget2, deepLinkedMomentId) then -- inferred equivalent call
				v = deepLinkTarget2
				break
			end
		end
	end

	return {
		kind = "unavailableMoment",
		targetId = deepLinkedMomentId,
		isModerated = v ~= nil and v.status ~= MomentStatus.Deleted and v.isModerated == true
	}
end

local function loadDeepLinkedMomentsForUnavailableDialog(fetchDeepLinkedMoments, deepLinkedMomentId: string, deepLinkedMomentTargetIdType: string?, deepLinkFetchTimeoutSeconds: number)
	local v = {
		fetchDeepLinkedMoments(deepLinkedMomentId, deepLinkedMomentTargetIdType):catch(function(): nil
			return nil
		end),
		(Promise.delay(deepLinkFetchTimeoutSeconds):andThen(function(): nil
			return nil
		end))
	}
	local v2, v3 = Promise.race(v):await()
	return if v2 and type(v3) == "table" then v3 else nil
end

local function createMomentsFeedSource(callback, options)
	local v = options or {}
	local v2

	if v.trendingStore == nil then
		v2 = MomentsGetMomentsTrendingStore(false)
	else
		v2 = v.trendingStore
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

	local deepLinkStore = v.deepLinkStore or GetDeepLinkStore()
	local fetchDeepLinkedMoments = v.fetchDeepLinkedMoments or defaultFetchDeepLinkedMoments
	local deepLinkFetchTimeoutSeconds = v.deepLinkFetchTimeoutSeconds or 20

	local nextCursor = nil
	local getPendingItems = nil

	if FFlagMomentsOptimisticProfilePending then
		local localUserId = v.localUserId or getLocalUserId()

		if localUserId ~= nil then
			getPendingItems = createPendingFeedGetter(localUserId, v.userStore or MomentsGetMomentsUserStore(false))
		end
	end

	return {
		id = "trending",
		getPendingItems = getPendingItems,
		recommendationSource = RecommendationSource.Trending,
		fetchAsync = function(p)
			local v4

			if v3 ~= nil then
				v4 = v3.getOwnerGeneration(false)
			end

			local v5 = p or nextCursor
			local signalTracker = v.signalTracker
			local v6

			if signalTracker then
				v6 = signalTracker:getSignalsPayload()
			end

			local v7, v8 = v2.getTrending(callback(false), v5, v6):await()

			if not v7 then
				error(v8)
			end

			local commentsByFeedItemId = v8.commentsByFeedItemId
			local comments

			if commentsByFeedItemId ~= nil then
				comments = {}

				for k, comment in commentsByFeedItemId do
					comments[k] = comment
				end
			end

			nextCursor = v8.nextCursor or nextCursor

			if p == nil then
				GetReactionsStore(false).clear()
				GetShareCountsStore(false).clear()
			end

			GetReactionsStore(false).setBatchReactionCounts(v8.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v8.shareInfoByMomentId or {})

			local items = {}
			local fn
			local momentId = nil
			local initialMomentId = nil

			if p == nil then
				local deepLinkedMomentId = deepLinkStore.getDeepLinkedMomentId(false)
				local deepLinkedMomentTargetIdType = deepLinkStore.getDeepLinkedMomentTargetIdType(false)

				if deepLinkedMomentId ~= nil then
					local v9 = {}
					local moment2 = nil

					for _, moment in v8.moments do
						v9[moment.momentId] = true

						if moment2 == nil and hasDeepLinkIdentity(moment, deepLinkedMomentId) then -- inferred equivalent call
							moment2 = moment
						end
					end

					local v10 = false
					local v11 = false

					local feedItemId = nil
					local v12

					if moment2 == nil then
						v12 = false
					else
						v12 = shouldShowMomentInFeed(moment2)
					end

					if v12 then
						table.insert(items, { kind = "moment", moment = moment2 })
						momentId = moment2.momentId
						v10 = true

						if FFlagMomentsCommentDeepLinks then
							feedItemId = moment2.recommendationMetadata.feedItemId
						end
					else
						local v13 = loadDeepLinkedMomentsForUnavailableDialog(
							fetchDeepLinkedMoments,
							deepLinkedMomentId,
							deepLinkedMomentTargetIdType,
							deepLinkFetchTimeoutSeconds
						)

						if v13 ~= nil then
							local commentsByFeedItemId2 = v13.commentsByFeedItemId

							if commentsByFeedItemId2 ~= nil then
								comments = comments or {}

								for k, comment in commentsByFeedItemId2 do
									comments[k] = comment
								end
							end

							if v13.reactionsByMomentId then
								GetReactionsStore(false).setBatchReactionCounts(v13.reactionsByMomentId)
							end

							if v13.shareInfoByMomentId then
								GetShareCountsStore(false).setBatchShareCounts(v13.shareInfoByMomentId)
							end

							for _, moment in v13.moments do
								local deepLinkIdentity = hasDeepLinkIdentity(moment, deepLinkedMomentId) -- inferred equivalent call

								if not (shouldShowMomentInFeed(moment) and deepLinkIdentity) then
									continue
								end

								table.insert(items, { kind = "moment", moment = moment })
								v10 = true

								if FFlagMomentsCommentDeepLinks then
									feedItemId = moment.recommendationMetadata.feedItemId
								end
							end

							v11 = not v10

							if FFlagMomentsModeratedMomentPage and v11 then
								table.insert(
									items,
									makeUnavailableMomentItem(deepLinkedMomentId, v13.moments, v8.moments)
								)
							end
						end
					end

					if v10 or v11 then
						local v13 = v11 and not FFlagMomentsModeratedMomentPage

						fn = function()
							if deepLinkStore.getDeepLinkedMomentId(false) == deepLinkedMomentId then
								deepLinkStore.setDeepLinkedMomentId(nil)

								if FFlagMomentsCommentDeepLinks then
									deepLinkStore.resolvePendingCommentsTarget(deepLinkedMomentId, feedItemId)
								end

								if v13 and v.onDeepLinkedMomentUnavailable ~= nil then
									v.onDeepLinkedMomentUnavailable()
								end
							end
						end
					end
				end
			end

			local onAccepted

			if FFlagMomentsComments then
				onAccepted = withCommentsSeeding(fn, v3, v4, comments) -- inferred equivalent call
			else
				onAccepted = fn
			end

			local v9 = items[1]

			if FFlagMomentsOptimisticProfilePending and p == nil and v9 ~= nil then
				if v9.kind == "moment" then
					initialMomentId = v9.moment.momentId
				elseif v9.kind == "unavailableMoment" then
					initialMomentId = v9.targetId
				end
			end

			for _, moment in v8.moments do
				Analytics.reportMomentsFeedItemsReceived(RecommendationSource.Trending)
				local v10

				if momentId == nil then
					v10 = false
				else
					v10 = moment.momentId == momentId
				end

				if v10 then
					continue
				end

				if shouldShowMomentInFeed(moment) then
					table.insert(items, { kind = "moment", moment = moment })
				else
					reportUnavailableFeedItem(moment, RecommendationSource.Trending)
				end
			end

			if FFlagMomentsRenderAvatarPostsInFeed then
				items = hydrateAvatarMomentFeedItems(items, v.postAssetStore or MomentsGetPostAssetStore(false))
			end

			return {
				items = items,
				initialMomentId = initialMomentId,
				nextCursor = v8.nextCursor,
				onAccepted = onAccepted
			}
		end
	}
end

return createMomentsFeedSource
