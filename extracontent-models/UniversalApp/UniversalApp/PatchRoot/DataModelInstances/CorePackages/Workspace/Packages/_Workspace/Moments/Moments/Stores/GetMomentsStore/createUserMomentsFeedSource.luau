local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)
require(Moments.Components.Feed)

local RecommendationSource = MomentsCommon.Analytics.RecommendationSource
local MomentsGetMomentsUserStore = require(MomentsParent.DataHydration.MomentsGetMomentsUserStore)

require(MomentsParent.DataHydration.MomentsStoreTypes)

local shouldShowMomentInFeed = require(script.Parent.shouldShowMomentInFeed)
local GetReactionsStore = require(Moments.Stores.GetReactionsStore)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetDeletedMomentsStore = require(Moments.Stores.GetDeletedMomentsStore)
local FFlagProfileMomentsOrderingAndReactions = require(MomentsParent.SharedFlags).FFlagProfileMomentsOrderingAndReactions
local FFlagMomentsRemoveDeletedFromProfile = require(MomentsParent.SharedFlags).FFlagMomentsRemoveDeletedFromProfile
local GetFFlagMomentsFilterUnavailableFeedItems = require(Moments.Flags.GetFFlagMomentsFilterUnavailableFeedItems)

local function createUserMomentsFeedSource(n1: number, t1: {[any]: any}?) -- line: 36
	-- upvalues: MomentsGetMomentsUserStore (copy), RecommendationSource (copy), FFlagProfileMomentsOrderingAndReactions (copy), GetReactionsStore (copy), GetShareCountsStore (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), shouldShowMomentInFeed (copy)
	local v16 = t1 or {}
	local v17 = if v16.userStore == nil then MomentsGetMomentsUserStore(false) else v16.userStore
	local initialIndex = v16.initialIndex

	return {
		id = `profile:{ n1 }`,
		recommendationSource = RecommendationSource.Profile,
		fetchAsync = function(p1) -- line: 45
			-- upvalues: v17 (copy), n1 (copy), FFlagProfileMomentsOrderingAndReactions (copy), GetReactionsStore (copy), GetShareCountsStore (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), shouldShowMomentInFeed (copy), initialIndex (copy)
			local t2 = {}
			local v21 = p1 == nil

			repeat
				local v22, v23 = v17.getUserMoments(n1, p1):await()

				if not v22 then
					error(v23)
				end

				if FFlagProfileMomentsOrderingAndReactions then
					GetReactionsStore(false).setBatchReactionCounts(v23.reactionsByMomentId or {})
					GetShareCountsStore(false).setBatchShareCounts(v23.shareInfoByMomentId or {})
				end

				local v24 = if not FFlagMomentsRemoveDeletedFromProfile then nil else GetDeletedMomentsStore(false).getDeletedIds(false)

				for _, v26 in v23.moments do
					if (v24 == nil or table.find(v24, v26.momentId) == nil) and (not GetFFlagMomentsFilterUnavailableFeedItems() or shouldShowMomentInFeed(v26)) then
						table.insert(t2, {
							kind = "moment",
							moment = v26
						})
					end
				end

				p1 = v23.nextCursor
			until not v21 or (initialIndex == nil or (not (#t2 < initialIndex) or p1 == nil))

			return {
				items = t2,
				nextCursor = p1
			}
		end
	}
end

return createUserMomentsFeedSource
