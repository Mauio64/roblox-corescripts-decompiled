local HttpService = game:GetService("HttpService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local react = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local formatRecommendationContextType = dependencies.SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local buildUserSeenCollectionPayload = dependencies.SocialLuaAnalytics.Analytics.buildUserSeenCollectionPayload
local repeatValue = dependencies.SocialLuaAnalytics.Analytics.Formatters.repeatValue
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/DataHydration")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Impressions")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/EventNames")
local getFriendStatus = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/getFriendStatus")
local useBatchedImpressions = Impressions.useBatchedImpressions

local FFlagMigrateFriendshipStatusesPYMK = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagMigrateFriendshipStatusesPYMK")
local FFlagPymkCarouselPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPymkCarouselPresenceStoreMigration")
local fIntUserSeenCollectionBatchTimeMs = SharedFlags.FIntUserSeenCollectionBatchTimeMs
local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagPYMKCarouselStableSelectors = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPYMKCarouselStableSelectors")

local frozen = table.freeze({})

local v5 = if FFlagPymkCarouselPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil

local v6 = if FFlagMigrateFriendshipStatusesPYMK then DataHydration.Friends.FriendsStore.get() else nil

local function getHydratedFriendshipStatus(p2)
	local friendshipStatus = v6.GetFriendshipStatus(p2, { skipFetch = true })

	if friendshipStatus then
		return (friendshipStatus.data(false))
	end

	return nil
end

return function(p2, data)
	local v7

	if FFlagMigrateFriendshipStatusesPYMK then
		v7 = nil
	else
		v7 = useSelector(function(p3)
			local v8 = getDeepValue(p3, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY))

			if v8 then
				return v8
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			v8 = {}
			return v8
		end)
	end

	local v8

	if fFlagLuaAppEnableSduiHomePage then
		v8 = nil
	else
		v8 = useSelector(function(p3)
			local v9 = getDeepValue(
				p3,
				string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)
			)

			if v9 then
				return v9
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			v9 = {}
			return v9
		end)
	end

	local v9

	if FFlagPymkCarouselPresenceStoreMigration then
		v9 = nil
	else
		v9 = useSelector(function(p3)
			local v10 = getDeepValue(p3, "PYMKCarousel.Presence.byUserId")

			if v10 then
				return v10
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			v10 = {}
			return v10
		end)
	end

	local useCallback = react.useCallback
	local function fn(p3, p4)
		local userSeenCollectionPayload = buildUserSeenCollectionPayload(p3, p4)
		local userSeenCollection = EventNames.UserSeenCollection
		local v11 = {
			userId = userSeenCollectionPayload.userIds,
			absolutePosition = userSeenCollectionPayload.absolutePositions,
			presence = userSeenCollectionPayload.presences,
			recommendationRank = userSeenCollectionPayload.recommendationRanks,
			friendStatus = userSeenCollectionPayload.friendStatuses,
			recommendationContextType = userSeenCollectionPayload.recommendationContextTypes,
			isRecommendation = userSeenCollectionPayload.isRecommendations,
			universeId = userSeenCollectionPayload.universeIds,
			tileCount = userSeenCollectionPayload.tileCount,
			sessionEventCount = userSeenCollectionPayload.sessionEventCount,
			contentType = 0,
			interactionUuid = 0,
			collectionId = 0,
			collectionPosition = 0,
			positionsInRow = 0,
			rowNumbers = 0,
			feedRowNumbers = 0,
			totalNumberOfItems = 0
		}
		local v12 = if fFlagLuaAppUserSeenCollectionUnifiedFields then userSeenCollectionPayload.contentType else nil
		v11.contentType = v12

		local v13 = if fFlagLuaAppUserSeenCollectionUnifiedFields then HttpService:GenerateGUID(false) else nil
		v11.interactionUuid = v13

		local v14 = if fFlagLuaAppUserSeenCollectionUnifiedFields and data then data.collectionId else nil
		v11.collectionId = v14

		local v15 = if fFlagLuaAppUserSeenCollectionUnifiedFields and data then data.collectionPosition else nil
		v11.collectionPosition = v15

		local v16 = if fFlagLuaAppUserSeenCollectionUnifiedFields then userSeenCollectionPayload.absolutePositions else nil
		v11.positionsInRow = v16

		local v17 = if fFlagLuaAppUserSeenCollectionUnifiedFields then repeatValue(1, userSeenCollectionPayload.tileCount) else nil
		v11.rowNumbers = v17

		local v18 = if fFlagLuaAppUserSeenCollectionUnifiedFields and data and data.feedRowNumber then repeatValue(
			data.feedRowNumber,
			userSeenCollectionPayload.tileCount
		) else nil
		v11.feedRowNumbers = v18

		local v19 = if fFlagLuaAppUserSeenCollectionUnifiedFields and data then data.totalNumberOfItems else nil
		v11.totalNumberOfItems = v19
		p2(userSeenCollection, v11)
	end

	local collectionId = if fFlagLuaAppUserSeenCollectionUnifiedFields and data then data.collectionId else nil
	local collectionPosition

	if fFlagLuaAppUserSeenCollectionUnifiedFields and data then
		collectionPosition = data.collectionPosition
	end

	local feedRowNumber = if fFlagLuaAppUserSeenCollectionUnifiedFields and data then data.feedRowNumber else nil
	local v11 = if fFlagLuaAppUserSeenCollectionUnifiedFields and data then data.totalNumberOfItems else nil
	local v12 = useCallback(fn, {
		p2,
		collectionId,
		collectionPosition,
		feedRowNumber,
		v11
	})

	local useCallback2 = react.useCallback
	local function fn2(p3, p4, data2)
		if not data2 or data2.isButtonTile or data2.isTooltip then
			return nil
		end

		local v13

		if FFlagPymkCarouselPresenceStoreMigration then
			v13 = v5.GetPresenceByUserId(tostring(p3), { skipFetch = true }).data(false) or {}
		else
			v13 = v9 and v9[p3] or {}
		end

		local v14 = (v13.universeId == nil or tostring(v13.universeId) == "") and -1 or v13.universeId

		local v15 = {
			userId = p3,
			index = data2.absolutePosition or p4,
			presence = v13.userPresenceType or "Offline",
			friendStatus = 0,
			recommendationContextType = 0,
			recommendationRank = 0,
			isRecommendation = true,
			universeId = 0
		}
		local v17

		if FFlagMigrateFriendshipStatusesPYMK then
			local friendshipStatus = v6.GetFriendshipStatus(p3, { skipFetch = true })

			if friendshipStatus then
				v17 = friendshipStatus.data(false)
			end
		else
			v17 = v7[p3]
		end

		local v18 = if fFlagLuaAppEnableSduiHomePage then data2.hasIncomingFriendRequest else v8[p3]
		v15.friendStatus = getFriendStatus(v17, v18)

		v15.recommendationContextType = not data2.recommendationContextType and "None"
			or formatRecommendationContextType(data2.recommendationContextType)

		v15.recommendationRank = data2.recommendationRank or -1

		v15.universeId = v14
		return v15
	end

	local v14 = if not FFlagMigrateFriendshipStatusesPYMK then v7 else nil
	local v18 = useBatchedImpressions({
		batchTimeMs = fIntUserSeenCollectionBatchTimeMs,
		mapItem = useCallback2(fn2, { v14, v8, if not FFlagPymkCarouselPresenceStoreMigration then v9 else nil }),
		onFlush = v12
	})

	return react.useMemo(function()
		return { addTileToCollection = v18.addImpression }
	end, { v18.addImpression })
end
