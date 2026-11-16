local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent
local Constants = require(parent.Common.Constants)
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local react = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local formatRecommendationContextType = dependencies.SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local buildUserSeenCollectionPayload = dependencies.SocialLuaAnalytics.Analytics.buildUserSeenCollectionPayload
local repeatValue = dependencies.SocialLuaAnalytics.Analytics.Formatters.repeatValue
local DataHydration = require(parent2.DataHydration)
local Impressions = require(parent2.Impressions)
local SharedFlags = require(parent2.SharedFlags)

local EventNames = require(script.Parent.EventNames)
local getFriendStatus = require(script.Parent.getFriendStatus)
local useBatchedImpressions = Impressions.useBatchedImpressions

local FFlagMigrateFriendshipStatusesPYMK = require(parent.Flags.FFlagMigrateFriendshipStatusesPYMK)
local FFlagPymkCarouselPresenceStoreMigration = require(parent.Flags.FFlagPymkCarouselPresenceStoreMigration)
local FIntUserSeenCollectionBatchTimeMs = SharedFlags.FIntUserSeenCollectionBatchTimeMs
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagPYMKCarouselStableSelectors = require(parent.Flags.FFlagPYMKCarouselStableSelectors)

local frozen = table.freeze({})
local v

if FFlagPymkCarouselPresenceStoreMigration then
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local v2

if FFlagMigrateFriendshipStatusesPYMK then
	v2 = DataHydration.Friends.FriendsStore.get()
else
	v2 = nil
end

local function getHydratedFriendshipStatus(p: string) -- 1 equivalent call inferred from this helper
	local friendshipStatus = v2.GetFriendshipStatus(p, { skipFetch = true })

	if friendshipStatus then
		return (friendshipStatus.data(false))
	end

	return nil
end

return function(callback, data)
	local v3

	if FFlagMigrateFriendshipStatusesPYMK then
		v3 = nil
	else
		v3 = useSelector(function(p)
			local v4 = getDeepValue(p, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY))

			if v4 then
				return v4
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			return {}
		end)
	end

	local v4

	if FFlagLuaAppEnableSduiHomePage then
		v4 = nil
	else
		v4 = useSelector(function(p)
			local v5 = getDeepValue(
				p,
				string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)
			)

			if v5 then
				return v5
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			return {}
		end)
	end

	local v5

	if FFlagPymkCarouselPresenceStoreMigration then
		v5 = nil
	else
		v5 = useSelector(function(p)
			local v6 = getDeepValue(p, "PYMKCarousel.Presence.byUserId")

			if v6 then
				return v6
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			return {}
		end)
	end

	local useCallback = react.useCallback
	local function fn(p, p2: number)
		local userSeenCollectionPayload = buildUserSeenCollectionPayload(p, p2)
		local userSeenCollection = EventNames.UserSeenCollection
		local v6 = {
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
		local contentType

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			contentType = userSeenCollectionPayload.contentType
		end

		v6.contentType = contentType
		local interactionUuid

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			interactionUuid = HttpService:GenerateGUID(false)
		end

		v6.interactionUuid = interactionUuid
		local collectionId

		if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
			collectionId = data.collectionId
		end

		v6.collectionId = collectionId
		local collectionPosition

		if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
			collectionPosition = data.collectionPosition
		end

		v6.collectionPosition = collectionPosition
		local positionsInRow

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			positionsInRow = userSeenCollectionPayload.absolutePositions
		end

		v6.positionsInRow = positionsInRow
		local rowNumbers

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			rowNumbers = repeatValue(1, userSeenCollectionPayload.tileCount)
		end

		v6.rowNumbers = rowNumbers
		local feedRowNumbers

		if FFlagLuaAppUserSeenCollectionUnifiedFields and data and data.feedRowNumber then
			feedRowNumbers = repeatValue(data.feedRowNumber, userSeenCollectionPayload.tileCount)
		end

		v6.feedRowNumbers = feedRowNumbers
		local totalNumberOfItems

		if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
			totalNumberOfItems = data.totalNumberOfItems
		end

		v6.totalNumberOfItems = totalNumberOfItems
		callback(userSeenCollection, v6)
	end

	local collectionId

	if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
		collectionId = data.collectionId
	end

	local collectionPosition

	if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
		collectionPosition = data.collectionPosition
	end

	local feedRowNumber

	if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
		feedRowNumber = data.feedRowNumber
	end

	local v6

	if FFlagLuaAppUserSeenCollectionUnifiedFields and data then
		v6 = data.totalNumberOfItems
	end

	local onFlush = useCallback(fn, {
		callback,
		collectionId,
		collectionPosition,
		feedRowNumber,
		v6
	})

	local useCallback2 = react.useCallback
	local function fn2(userId: string, p: number, data2)
		if not data2 or data2.isButtonTile or data2.isTooltip then
			return nil
		end

		local v7

		if FFlagPymkCarouselPresenceStoreMigration then
			v7 = v.GetPresenceByUserId(tostring(userId), { skipFetch = true }).data(false) or {}
		else
			v7 = v5 and v5[userId] or {}
		end

		local universeId = (v7.universeId == nil or tostring(v7.universeId) == "") and -1 or v7.universeId

		local v8 = {
			userId = userId,
			index = data2.absolutePosition or p,
			presence = v7.userPresenceType or "Offline",
			friendStatus = 0,
			recommendationContextType = 0,
			recommendationRank = 0,
			isRecommendation = true,
			universeId = 0
		}
		local v9

		if FFlagMigrateFriendshipStatusesPYMK then
			v9 = getHydratedFriendshipStatus(userId) -- inferred equivalent call
		else
			v9 = v3[userId]
		end

		local v10

		if FFlagLuaAppEnableSduiHomePage then
			v10 = data2.hasIncomingFriendRequest
		else
			v10 = v4[userId]
		end

		v8.friendStatus = getFriendStatus(v9, v10)

		v8.recommendationContextType = not data2.recommendationContextType and "None"
			or formatRecommendationContextType(data2.recommendationContextType)

		v8.recommendationRank = data2.recommendationRank or -1

		v8.universeId = universeId
		return v8
	end

	local v7

	if not FFlagMigrateFriendshipStatusesPYMK then
		v7 = v3
	end

	local v8

	if not FFlagPymkCarouselPresenceStoreMigration then
		v8 = v5
	end

	local v9 = useBatchedImpressions({
		batchTimeMs = FIntUserSeenCollectionBatchTimeMs,
		mapItem = useCallback2(fn2, { v7, v4, v8 }),
		onFlush = onFlush
	})

	return react.useMemo(function()
		return { addTileToCollection = v9.addImpression }
	end, { v9.addImpression })
end
