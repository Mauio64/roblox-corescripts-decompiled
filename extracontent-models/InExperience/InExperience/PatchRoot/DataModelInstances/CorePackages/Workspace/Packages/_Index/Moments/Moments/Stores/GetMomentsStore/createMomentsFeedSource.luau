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
local GetFFlagMomentsShareDeeplinkReliableOpen = require(Moments.Flags.GetFFlagMomentsShareDeeplinkReliableOpen)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis

local function defaultFetchDeepLinkedMoments(s1: string, s2: string?) -- line: 58
	-- upvalues: Promise (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchMomentsByIds (copy)
	return Promise.resolve():andThen(function() -- line: 59
		-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchMomentsByIds (copy), s1 (copy), s2 (copy)
		if FFlagMomentsPassFeedItemIdToBackendApis then
			return (fetchMomentsByIds({ s1 }, s2))
		end

		return (fetchMomentsByIds({ s1 }))
	end)
end
local function hasDeepLinkIdentity(p1, s3: string) -- line: 72
	if s3 == p1.momentId then
		return true
	end

	local recommendationMetadata = p1.recommendationMetadata

	return recommendationMetadata ~= nil and s3 == recommendationMetadata.feedItemId
end
local function loadDeepLinkedMoments(p2: ((...any) -> ...any), s4: string, s5: string?, n1: number) -- line: 82
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), Promise (copy)
	local v31 = ((if not FFlagMomentsPassFeedItemIdToBackendApis then p2(s4) else p2(s4, s5))):catch(function() -- line: 92
		return nil
	end)
	local v32 = Promise.delay(n1):andThen(function() -- line: 95
		return nil
	end)
	local v33, v34 = Promise.race({
		v31,
		v32
	}):await()

	if v33 and type(v34) == "table" then
		return v34
	end

	return {
		reactionsByMomentId = nil,
		shareInfoByMomentId = nil,
		moments = {}
	}
end
local function loadDeepLinkedMomentsForUnavailableDialog(p3: ((...any) -> ...any), s6: string, s7: string?, n2: number) -- line: 108
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), Promise (copy)
	local v39 = ((if not FFlagMomentsPassFeedItemIdToBackendApis then p3(s6) else p3(s6, s7))):catch(function() -- line: 117
		return nil
	end)
	local v40 = Promise.delay(n2):andThen(function() -- line: 120
		return nil
	end)
	local v41, v42 = Promise.race({
		v39,
		v40
	}):await()

	if v41 and type(v42) == "table" then
		return v42
	end

	return nil
end
local function createMomentsFeedSource(p4, t1: {[any]: any}?) -- line: 131
	-- upvalues: MomentsGetMomentsTrendingStore (copy), GetDeepLinkStore (copy), defaultFetchDeepLinkedMoments (copy), GetFFlagMomentsFixUnavailableDeeplink (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), RecommendationSource (copy), GetReactionsStore (copy), GetShareCountsStore (copy), GetFFlagMomentsShareDeeplinkReliableOpen (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), shouldShowMomentInFeed (copy), loadDeepLinkedMomentsForUnavailableDialog (copy), loadDeepLinkedMoments (copy)
	local v45 = t1 or {}
	local v46 = if v45.trendingStore == nil then MomentsGetMomentsTrendingStore(false) else v45.trendingStore
	local v47 = v45.deepLinkStore or GetDeepLinkStore()
	local v48 = v45.fetchDeepLinkedMoments or defaultFetchDeepLinkedMoments
	local v49 = v45.deepLinkFetchTimeoutSeconds or 20
	local v50 = GetFFlagMomentsFixUnavailableDeeplink() and GetFFlagMomentsFilterUnavailableFeedItems()
	local u51 = nil

	return {
		id = "trending",
		recommendationSource = RecommendationSource.Trending,
		fetchAsync = function(p5) -- line: 151
			-- upvalues: u51 (ref), v45 (copy), v46 (copy), p4 (copy), GetReactionsStore (copy), GetShareCountsStore (copy), GetFFlagMomentsShareDeeplinkReliableOpen (copy), v47 (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), shouldShowMomentInFeed (copy), v50 (copy), loadDeepLinkedMomentsForUnavailableDialog (copy), v48 (copy), v49 (copy), loadDeepLinkedMoments (copy)
			local v53 = p5 or u51
			local signalTracker = v45.signalTracker
			local v55 = if not signalTracker then nil else signalTracker:getSignalsPayload()
			local v56, v57 = v46.getTrending(p4(false), v53, v55):await()

			if not v56 then
				error(v57)
			end

			u51 = v57.nextCursor or u51

			if p5 == nil then
				GetReactionsStore(false).clear()
				GetShareCountsStore(false).clear()
			end

			GetReactionsStore(false).setBatchReactionCounts(v57.reactionsByMomentId or {})
			GetShareCountsStore(false).setBatchShareCounts(v57.shareInfoByMomentId or {})

			local t2 = {}
			local v59 = nil
			local momentId = nil

			if p5 == nil then
				if GetFFlagMomentsShareDeeplinkReliableOpen() then
					local v61 = v47.getDeepLinkedMomentId(false)
					local v62 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else v47.getDeepLinkedMomentTargetIdType(false)

					if v61 ~= nil then
						local t3 = {}
						local v64 = nil

						for _, v66 in v57.moments do
							t3[v66.momentId] = true

							if v64 == nil then
								local v67

								if v61 == v66.momentId then
									v67 = true
								else
									local recommendationMetadata = v66.recommendationMetadata

									v67 = recommendationMetadata ~= nil and v61 == recommendationMetadata.feedItemId
								end

								if v67 then
									v64 = v66
								end
							end
						end

						local v69 = false
						local v70 = false

						if v64 ~= nil and (not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v64)) then
							table.insert(t2, {
								kind = "moment",
								moment = v64
							})
							momentId = v64.momentId
							v69 = true
						elseif v64 == nil or v50 then
							local v71 = if not v50 then loadDeepLinkedMoments(v48, v61, v62, v49) else loadDeepLinkedMomentsForUnavailableDialog(v48, v61, v62, v49)

							if v71 ~= nil then
								if v71.reactionsByMomentId then
									GetReactionsStore(false).setBatchReactionCounts(v71.reactionsByMomentId)
								end

								if v71.shareInfoByMomentId then
									GetShareCountsStore(false).setBatchShareCounts(v71.shareInfoByMomentId)
								end

								for _, v73 in v71.moments do
									local v74

									if v61 == v73.momentId then
										v74 = true
									else
										local recommendationMetadata = v73.recommendationMetadata

										v74 = recommendationMetadata ~= nil and v61 == recommendationMetadata.feedItemId
									end

									local v76 = not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v73)
									local v77 = not v50 or v74
									local v78 = v74 or not t3[v73.momentId]

									if v76 and v77 and v78 then
										table.insert(t2, {
											kind = "moment",
											moment = v73
										})

										if v74 then
											v69 = true
										end
									end
								end

								v70 = v50 and not v69
							end
						end

						if v69 or v70 then
							local v79 = v70

							function v59() -- line: 270
								-- upvalues: v47 (copy), v61 (copy), v79 (copy), v45 (copy)
								if v47.getDeepLinkedMomentId(false) == v61 then
									v47.setDeepLinkedMomentId(nil)

									if v79 and v45.onDeepLinkedMomentUnavailable ~= nil then
										v45.onDeepLinkedMomentUnavailable()
									end
								end
							end
						end
					end
				else
					local v80 = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else v47.consumeDeepLinkedMoment()

					if not FFlagMomentsPassFeedItemIdToBackendApis then
						local v81 = v47.consumeDeepLinkedMomentId()

						if v81 ~= nil then
							v80 = {
								targetIdType = nil,
								targetId = v81
							}
						end
					end

					if v80 ~= nil then
						local targetId = v80.targetId
						local targetIdType = v80.targetIdType
						local t4 = {}
						local v85 = false

						for _, v87 in v57.moments do
							t4[v87.momentId] = true

							if v50 then
								local v88

								if targetId == v87.momentId then
									v88 = true
								else
									local recommendationMetadata = v87.recommendationMetadata

									v88 = recommendationMetadata ~= nil and targetId == recommendationMetadata.feedItemId
								end

								if v88 and shouldShowMomentInFeed(v87) then
									v85 = true
								end
							end
						end

						local v90 = if not v50 then loadDeepLinkedMoments(v48, targetId, targetIdType, v49) else loadDeepLinkedMomentsForUnavailableDialog(v48, targetId, targetIdType, v49)

						if v90 ~= nil then
							if v90.reactionsByMomentId then
								GetReactionsStore(false).setBatchReactionCounts(v90.reactionsByMomentId)
							end

							if v90.shareInfoByMomentId then
								GetShareCountsStore(false).setBatchShareCounts(v90.shareInfoByMomentId)
							end

							for _, v92 in v90.moments do
								local v93 = not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v92)
								local v94 = not v50

								if not v94 then
									if targetId == v92.momentId then
										v94 = true
									else
										local recommendationMetadata = v92.recommendationMetadata

										v94 = recommendationMetadata ~= nil and targetId == recommendationMetadata.feedItemId
									end
								end

								if v50 and v94 and v93 then
									v85 = true
								end

								if v93 and v94 and not t4[v92.momentId] then
									table.insert(t2, {
										kind = "moment",
										moment = v92
									})
								end
							end

							if v50 and not v85 and v45.onDeepLinkedMomentUnavailable ~= nil then
								v45.onDeepLinkedMomentUnavailable()
							end
						end
					end
				end
			end

			for _, v97 in v57.moments do
				if (not GetFFlagMomentsShareDeeplinkReliableOpen() or (momentId == nil or momentId ~= v97.momentId)) and if not GetFFlagMomentsFilterUnavailableFeedItems() then not v97.isModerated else shouldShowMomentInFeed(v97) then
					table.insert(t2, {
						kind = "moment",
						moment = v97
					})
				end
			end

			return {
				items = t2,
				nextCursor = v57.nextCursor,
				onAccepted = v59
			}
		end
	}
end

return createMomentsFeedSource
