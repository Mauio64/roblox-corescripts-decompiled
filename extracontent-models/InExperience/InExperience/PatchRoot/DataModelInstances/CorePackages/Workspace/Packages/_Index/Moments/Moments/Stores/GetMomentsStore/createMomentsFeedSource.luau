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
local GetFFlagMomentsFixUnavailableDeeplink = require(Moments.Flags.GetFFlagMomentsFixUnavailableDeeplink)

local function defaultFetchDeepLinkedMoments(s1: string) -- line: 55
	-- upvalues: Promise (copy), fetchMomentsByIds (copy)
	return Promise.resolve():andThen(function() -- line: 56
		-- upvalues: fetchMomentsByIds (copy), s1 (copy)
		return fetchMomentsByIds({ s1 })
	end)
end
local function loadDeepLinkedMoments(p1: ((...any) -> ...any), s2: string, n1: number) -- line: 69
	-- upvalues: Promise (copy)
	local v22 = p1(s2):catch(function() -- line: 75
		return nil
	end)
	local v23 = Promise.delay(n1):andThen(function() -- line: 78
		return nil
	end)
	local v24, v25 = Promise.race({
		v22,
		v23
	}):await()

	if v24 and type(v25) == "table" then
		return v25
	end

	return {
		reactionsByMomentId = nil,
		shareInfoByMomentId = nil,
		moments = {}
	}
end
local function loadDeepLinkedMomentsForUnavailableDialog(p2: ((...any) -> ...any), s3: string, n2: number) -- line: 91
	-- upvalues: Promise (copy)
	local v29 = p2(s3):catch(function() -- line: 96
		return nil
	end)
	local v30 = Promise.delay(n2):andThen(function() -- line: 99
		return nil
	end)
	local v31, v32 = Promise.race({
		v29,
		v30
	}):await()

	if v31 and type(v32) == "table" then
		return v32
	end

	return nil
end
local function createMomentsFeedSource(p3, t1: {[any]: any}?) -- line: 110
	-- upvalues: MomentsGetMomentsTrendingStore (copy), GetDeepLinkStore (copy), defaultFetchDeepLinkedMoments (copy), GetFFlagMomentsFixUnavailableDeeplink (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), RecommendationSource (copy), GetReactionsStore (copy), GetShareCountsStore (copy), shouldShowMomentInFeed (copy), loadDeepLinkedMomentsForUnavailableDialog (copy), loadDeepLinkedMoments (copy)
	local v35 = t1 or {}
	local v36 = if v35.trendingStore == nil then MomentsGetMomentsTrendingStore(false) else v35.trendingStore
	local v37 = v35.deepLinkStore or GetDeepLinkStore()
	local v38 = v35.fetchDeepLinkedMoments or defaultFetchDeepLinkedMoments
	local v39 = v35.deepLinkFetchTimeoutSeconds or 20
	local v40 = GetFFlagMomentsFixUnavailableDeeplink() and GetFFlagMomentsFilterUnavailableFeedItems()
	local u41 = nil

	return {
		id = "trending",
		recommendationSource = RecommendationSource.Trending,
		fetchAsync = function(p4) -- line: 130
			-- upvalues: u41 (ref), v35 (copy), v36 (copy), p3 (copy), GetReactionsStore (copy), GetShareCountsStore (copy), v37 (copy), v40 (copy), shouldShowMomentInFeed (copy), loadDeepLinkedMomentsForUnavailableDialog (copy), v38 (copy), v39 (copy), loadDeepLinkedMoments (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy)
			local v43 = p4 or u41
			local signalTracker = v35.signalTracker
			local v45 = if not signalTracker then nil else signalTracker:getSignalsPayload()
			local v46, v47 = v36.getTrending(p3(false), v43, v45):await()

			if not v46 then
				error(v47)
			end

			u41 = v47.nextCursor or u41

			if p4 == nil then
				GetReactionsStore(false).clear()
				GetShareCountsStore(false).clear()
			end

			GetReactionsStore(false).setBatchReactionCounts(v47.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v47.shareInfoByMomentId or {})

			local t2 = {}

			if p4 == nil then
				local v49 = v37.consumeDeepLinkedMomentId()

				if v49 ~= nil then
					local t3 = {}
					local v51 = false

					for _, v53 in v47.moments do
						t3[v53.momentId] = true

						if v40 and v49 == v53.momentId and shouldShowMomentInFeed(v53) then
							v51 = true
						end
					end

					local v54 = if not v40 then loadDeepLinkedMoments(v38, v49, v39) else loadDeepLinkedMomentsForUnavailableDialog(v38, v49, v39)

					if v54 ~= nil then
						if v54.reactionsByMomentId then
							GetReactionsStore(false).setBatchReactionCounts(v54.reactionsByMomentId)
						end

						if v54.shareInfoByMomentId then
							GetShareCountsStore(false).setBatchShareCounts(v54.shareInfoByMomentId)
						end

						for _, v56 in v54.moments do
							local v57 = not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v56)
							local v58 = not v40 or v49 == v56.momentId

							if v40 and v58 and v57 then
								v51 = true
							end

							if v57 and v58 and not t3[v56.momentId] then
								table.insert(t2, {
									kind = "moment",
									moment = v56
								})
							end
						end

						if v40 and not v51 and v35.onDeepLinkedMomentUnavailable ~= nil then
							v35.onDeepLinkedMomentUnavailable()
						end
					end
				end
			end

			for _, v60 in v47.moments do
				if if not GetFFlagMomentsFilterUnavailableFeedItems() then not v60.isModerated else shouldShowMomentInFeed(v60) then
					table.insert(t2, {
						kind = "moment",
						moment = v60
					})
				end
			end

			return {
				items = t2,
				nextCursor = v47.nextCursor
			}
		end
	}
end

return createMomentsFeedSource
