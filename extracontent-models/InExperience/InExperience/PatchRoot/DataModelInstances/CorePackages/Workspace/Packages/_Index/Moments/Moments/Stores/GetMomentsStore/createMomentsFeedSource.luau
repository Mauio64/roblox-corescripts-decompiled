local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.Signals)

local Promise = require(MomentsParent.Promise)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local SharedFlags = require(MomentsParent.SharedFlags)

require(Moments.Components.Feed)

local RecommendationSource = MomentsCommon.Analytics.RecommendationSource

require(Moments.SignalTracker)

local MomentsGetMomentsTrendingStore = require(MomentsParent.DataHydration.MomentsGetMomentsTrendingStore)

require(MomentsParent.DataHydration.MomentsStoreTypes)

local fetchMomentsByIds = require(script.Parent.fetchMomentsByIds)
local shouldShowMomentInFeed = require(script.Parent.shouldShowMomentInFeed)
local GetDeepLinkStore = require(Moments.Stores.GetDeepLinkStore)

require(Moments.Stores.GetDeepLinkStore.createDeepLinkStore)

local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetFFlagMomentsFilterUnavailableFeedItems = require(Moments.Flags.GetFFlagMomentsFilterUnavailableFeedItems)
local GetFFlagMomentsFixUnavailableDeeplink = require(Moments.Flags.GetFFlagMomentsFixUnavailableDeeplink)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis

local function defaultFetchDeepLinkedMoments(s1: string, s2: string?) -- line: 57
	-- upvalues: Promise (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchMomentsByIds (copy)
	return Promise.resolve():andThen(function() -- line: 58
		-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchMomentsByIds (copy), s1 (copy), s2 (copy)
		if FFlagMomentsPassFeedItemIdToBackendApis then
			return (fetchMomentsByIds({ s1 }, s2))
		end

		return (fetchMomentsByIds({ s1 }))
	end)
end
local function hasDeepLinkIdentity(p1, s3: string) -- line: 71
	if s3 == p1.momentId then
		return true
	end

	local recommendationMetadata = p1.recommendationMetadata

	return recommendationMetadata ~= nil and s3 == recommendationMetadata.feedItemId
end
local function loadDeepLinkedMoments(p2: ((...any) -> ...any), s4: string, s5: string?, n1: number) -- line: 81
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), Promise (copy)
	local v30 = ((if not FFlagMomentsPassFeedItemIdToBackendApis then p2(s4) else p2(s4, s5))):catch(function() -- line: 91
		return nil
	end)
	local v31 = Promise.delay(n1):andThen(function() -- line: 94
		return nil
	end)
	local v32, v33 = Promise.race({
		v30,
		v31
	}):await()

	if v32 and type(v33) == "table" then
		return v33
	end

	return {
		reactionsByMomentId = nil,
		shareInfoByMomentId = nil,
		moments = {}
	}
end
local function loadDeepLinkedMomentsForUnavailableDialog(p3: ((...any) -> ...any), s6: string, s7: string?, n2: number) -- line: 107
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), Promise (copy)
	local v38 = ((if not FFlagMomentsPassFeedItemIdToBackendApis then p3(s6) else p3(s6, s7))):catch(function() -- line: 116
		return nil
	end)
	local v39 = Promise.delay(n2):andThen(function() -- line: 119
		return nil
	end)
	local v40, v41 = Promise.race({
		v38,
		v39
	}):await()

	if v40 and type(v41) == "table" then
		return v41
	end

	return nil
end
local function createMomentsFeedSource(p4, t1: {[any]: any}?) -- line: 130
	-- upvalues: MomentsGetMomentsTrendingStore (copy), GetDeepLinkStore (copy), defaultFetchDeepLinkedMoments (copy), GetFFlagMomentsFixUnavailableDeeplink (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), RecommendationSource (copy), GetReactionsStore (copy), GetShareCountsStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), shouldShowMomentInFeed (copy), loadDeepLinkedMomentsForUnavailableDialog (copy), loadDeepLinkedMoments (copy)
	local v44 = t1 or {}
	local v45 = if v44.trendingStore == nil then MomentsGetMomentsTrendingStore(false) else v44.trendingStore
	local v46 = v44.deepLinkStore or GetDeepLinkStore()
	local v47 = v44.fetchDeepLinkedMoments or defaultFetchDeepLinkedMoments
	local v48 = v44.deepLinkFetchTimeoutSeconds or 20
	local v49 = GetFFlagMomentsFixUnavailableDeeplink() and GetFFlagMomentsFilterUnavailableFeedItems()
	local u50 = nil

	return {
		id = "trending",
		recommendationSource = RecommendationSource.Trending,
		fetchAsync = function(p5) -- line: 150
			-- upvalues: u50 (ref), v44 (copy), v45 (copy), p4 (copy), GetReactionsStore (copy), GetShareCountsStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), v46 (copy), v49 (copy), shouldShowMomentInFeed (copy), loadDeepLinkedMomentsForUnavailableDialog (copy), v47 (copy), v48 (copy), loadDeepLinkedMoments (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy)
			local v52 = p5 or u50
			local signalTracker = v44.signalTracker
			local v54 = if not signalTracker then nil else signalTracker:getSignalsPayload()
			local v55, v56 = v45.getTrending(p4(false), v52, v54):await()

			if not v55 then
				error(v56)
			end

			u50 = v56.nextCursor or u50

			if p5 == nil then
				GetReactionsStore(false).clear()
				GetShareCountsStore(false).clear()
			end

			GetReactionsStore(false).setBatchReactionCounts(v56.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v56.shareInfoByMomentId or {})

			local t2 = {}

			if p5 == nil then
				local v58 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else v46.consumeDeepLinkedMoment()

				if not FFlagMomentsPassFeedItemIdToBackendApis then
					local v59 = v46.consumeDeepLinkedMomentId()

					if v59 ~= nil then
						v58 = {
							targetIdType = nil,
							targetId = v59
						}
					end
				end

				if v58 ~= nil then
					local targetId = v58.targetId
					local targetIdType = v58.targetIdType
					local t3 = {}
					local v63 = false

					for _, v65 in v56.moments do
						t3[v65.momentId] = true

						if v49 then
							local v66

							if targetId == v65.momentId then
								v66 = true
							else
								local recommendationMetadata = v65.recommendationMetadata

								v66 = recommendationMetadata ~= nil and targetId == recommendationMetadata.feedItemId
							end

							if v66 and shouldShowMomentInFeed(v65) then
								v63 = true
							end
						end
					end

					local v68 = if not v49 then loadDeepLinkedMoments(v47, targetId, targetIdType, v48) else loadDeepLinkedMomentsForUnavailableDialog(v47, targetId, targetIdType, v48)

					if v68 ~= nil then
						if v68.reactionsByMomentId then
							GetReactionsStore(false).setBatchReactionCounts(v68.reactionsByMomentId)
						end

						if v68.shareInfoByMomentId then
							GetShareCountsStore(false).setBatchShareCounts(v68.shareInfoByMomentId)
						end

						for _, v70 in v68.moments do
							local v71 = not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v70)
							local v72 = not v49

							if not v72 then
								if targetId == v70.momentId then
									v72 = true
								else
									local recommendationMetadata = v70.recommendationMetadata

									v72 = recommendationMetadata ~= nil and targetId == recommendationMetadata.feedItemId
								end
							end

							if v49 and v72 and v71 then
								v63 = true
							end

							if v71 and v72 and not t3[v70.momentId] then
								table.insert(t2, {
									kind = "moment",
									moment = v70
								})
							end
						end

						if v49 and not v63 and v44.onDeepLinkedMomentUnavailable ~= nil then
							v44.onDeepLinkedMomentUnavailable()
						end
					end
				end
			end

			for _, v75 in v56.moments do
				if if not GetFFlagMomentsFilterUnavailableFeedItems() then not v75.isModerated else shouldShowMomentInFeed(v75) then
					table.insert(t2, {
						kind = "moment",
						moment = v75
					})
				end
			end

			return {
				items = t2,
				nextCursor = v56.nextCursor
			}
		end
	}
end

return createMomentsFeedSource
