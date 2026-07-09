local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.Signals)

local Promise = require(MomentsParent.Promise)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)
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

local function defaultFetchDeepLinkedMoments(s1: string) -- line: 52
	-- upvalues: Promise (copy), fetchMomentsByIds (copy)
	return Promise.resolve():andThen(function() -- line: 53
		-- upvalues: fetchMomentsByIds (copy), s1 (copy)
		return fetchMomentsByIds({ s1 })
	end)
end
local function loadDeepLinkedMoments(p1: ((...any) -> ...any), s2: string, n1: number) -- line: 66
	-- upvalues: Promise (copy)
	local v20 = p1(s2):catch(function() -- line: 72
		return nil
	end)
	local v21 = Promise.delay(n1):andThen(function() -- line: 75
		return nil
	end)
	local v22, v23 = Promise.race({
		v20,
		v21
	}):await()

	if v22 and type(v23) == "table" then
		return v23
	end

	return {
		reactionsByMomentId = nil,
		shareInfoByMomentId = nil,
		moments = {}
	}
end
local function createMomentsFeedSource(p2, t1: {[any]: any}?) -- line: 86
	-- upvalues: MomentsGetMomentsTrendingStore (copy), GetDeepLinkStore (copy), defaultFetchDeepLinkedMoments (copy), RecommendationSource (copy), GetReactionsStore (copy), GetShareCountsStore (copy), loadDeepLinkedMoments (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), shouldShowMomentInFeed (copy)
	local v26 = t1 or {}
	local v27 = if v26.trendingStore == nil then MomentsGetMomentsTrendingStore(false) else v26.trendingStore
	local v28 = v26.deepLinkStore or GetDeepLinkStore()
	local v29 = v26.fetchDeepLinkedMoments or defaultFetchDeepLinkedMoments
	local v30 = v26.deepLinkFetchTimeoutSeconds or 20
	local u31 = nil

	return {
		id = "trending",
		recommendationSource = RecommendationSource.Trending,
		fetchAsync = function(p3) -- line: 104
			-- upvalues: u31 (ref), v26 (copy), v27 (copy), p2 (copy), GetReactionsStore (copy), GetShareCountsStore (copy), v28 (copy), loadDeepLinkedMoments (copy), v29 (copy), v30 (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), shouldShowMomentInFeed (copy)
			local v33 = p3 or u31
			local signalTracker = v26.signalTracker
			local v35 = if not signalTracker then nil else signalTracker:getSignalsPayload()
			local v36, v37 = v27.getTrending(p2(false), v33, v35):await()

			if not v36 then
				error(v37)
			end

			u31 = v37.nextCursor or u31

			if p3 == nil then
				GetReactionsStore(false).clear()
				GetShareCountsStore(false).clear()
			end

			GetReactionsStore(false).setBatchReactionCounts(v37.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v37.shareInfoByMomentId or {})

			local t2 = {}

			if p3 == nil then
				local v39 = v28.consumeDeepLinkedMomentId()

				if v39 ~= nil then
					local t3 = {}

					for _, v42 in v37.moments do
						t3[v42.momentId] = true
					end

					local v43 = loadDeepLinkedMoments(v29, v39, v30)

					if v43.reactionsByMomentId then
						GetReactionsStore(false).setBatchReactionCounts(v43.reactionsByMomentId)
					end

					if v43.shareInfoByMomentId then
						GetShareCountsStore(false).setBatchShareCounts(v43.shareInfoByMomentId)
					end

					for _, v45 in v43.moments do
						if (not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v45)) and not t3[v45.momentId] then
							table.insert(t2, {
								kind = "moment",
								moment = v45
							})
						end
					end
				end
			end

			for _, v47 in v37.moments do
				if if not GetFFlagMomentsFilterUnavailableFeedItems() then not v47.isModerated else shouldShowMomentInFeed(v47) then
					table.insert(t2, {
						kind = "moment",
						moment = v47
					})
				end
			end

			return {
				items = t2,
				nextCursor = v37.nextCursor
			}
		end
	}
end

return createMomentsFeedSource
