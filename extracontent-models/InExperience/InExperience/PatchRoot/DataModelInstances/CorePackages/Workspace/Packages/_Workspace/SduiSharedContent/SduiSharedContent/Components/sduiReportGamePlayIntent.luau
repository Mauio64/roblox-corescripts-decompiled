local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local UnifiedLogging = require(parent.UnifiedLogging)
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry

local function sduiReportGamePlayIntent(data)
	local sduiContext = data.sduiContext
	local analyticsContext = data.analyticsContext
	local universeId = data.universeId
	local placeId = data.placeId
	local rootPlaceId = data.rootPlaceId or placeId
	local appliedFilters = data.appliedFilters
	local launchData = data.launchData

	local eventIngest = sduiContext.dependencies.eventIngest
	local sessionService = sduiContext.dependencies.sessionService

	local collectionPosition = nil
	local collectionId = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v

	if analyticsContext.getCollectionData then
		v = analyticsContext.getCollectionData() or nil
	end

	if v then
		collectionPosition = v.collectionPosition
		collectionId = v.collectionId
		itemsPerRow = v.itemsPerRow
		startRowNumber = v.startRowNumber
	end

	local v2 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", analyticsContext)
	local v3 = collectionId or findAnalyticsFieldInAncestors("collectionId", analyticsContext)
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("gameSetTargetId", analyticsContext)

	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("itemPosition", analyticsContext, -1)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors(
		"topicDataPosition",
		analyticsContext,
		analyticsFieldInAncestors2
	)

	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("heroUnitId", analyticsContext)

	local analyticsFieldInAncestors5 = findAnalyticsFieldInAncestors("eventContext", analyticsContext, "ExperienceTile")
	local analyticsFieldInAncestors6 = findAnalyticsFieldInAncestors("referralSource", analyticsContext)

	local analyticsFieldInAncestors7 = findAnalyticsFieldInAncestors("gamePlaySessionType", analyticsContext)

	if analyticsFieldInAncestors7 then
		SetGamePlaySession(sessionService, analyticsFieldInAncestors7, true)
	end

	local nativeAdData = findAnalyticsFieldInAncestors("nativeAdData", analyticsContext)

	if nativeAdData == nil then
		nativeAdData = findAnalyticsFieldInAncestors("adId", analyticsContext)
	end

	if nativeAdData then
		sponsoredGamesRecordClick(sduiContext.dependencies.networking, (tostring(nativeAdData)))
	end

	local v4 = (typeof(analyticsFieldInAncestors2) ~= "number" or typeof(itemsPerRow) ~= "number" or typeof(startRowNumber) ~= "number" or analyticsFieldInAncestors2 == -1 or itemsPerRow == -1 or startRowNumber == -1)
		and {}
		or calculateRowPositionFields(analyticsFieldInAncestors2, itemsPerRow, startRowNumber)

	local analyticsFieldInAncestors8 = findAnalyticsFieldInAncestors("tileType", analyticsContext, "GameTile")

	local v5 = tostring(analyticsFieldInAncestors5)
	local v6 = {
		placeId = tostring(placeId or rootPlaceId),
		rootPlaceId = tonumber(rootPlaceId),
		universeId = tostring(universeId),
		sortIndex = 0,
		sortEntryIndex = 0,
		referralSource = 0,
		gameSetTypeId = 0,
		gameSetTargetId = 0,
		appliedFilters = 0,
		topicDataPosition = 0,
		nativeAdData = 0,
		pageName = 0,
		positionInRow = 0,
		rowNumber = 0,
		feedRowNumber = 0,
		heroUnitId = 0,
		tileType = 0,
		launchData = 0,
		actionType = 0
	}
	local sortIndex

	if v2 then
		sortIndex = tostring(v2)
	end

	v6.sortIndex = sortIndex
	local sortEntryIndex

	if typeof(analyticsFieldInAncestors2) == "number" and analyticsFieldInAncestors2 ~= -1 then
		sortEntryIndex = tostring(analyticsFieldInAncestors2)
	end

	v6.sortEntryIndex = sortEntryIndex

	v6.referralSource = analyticsFieldInAncestors6
	local gameSetTypeId

	if v3 then
		gameSetTypeId = tostring(v3)
	end

	v6.gameSetTypeId = gameSetTypeId
	v6.gameSetTargetId = analyticsFieldInAncestors
	v6.appliedFilters = appliedFilters

	if
		typeof(analyticsFieldInAncestors3) ~= "number"
		or analyticsFieldInAncestors3 == -1
		or not analyticsFieldInAncestors3
	then
		analyticsFieldInAncestors3 = nil
	end

	v6.topicDataPosition = analyticsFieldInAncestors3

	v6.nativeAdData = nativeAdData
	v6.pageName = sduiContext.appPage
	v6.positionInRow = v4.positionInRow
	v6.rowNumber = v4.rowInSort
	v6.feedRowNumber = v4.rowOnPage
	v6.heroUnitId = analyticsFieldInAncestors4
	v6.tileType = analyticsFieldInAncestors8
	v6.launchData = launchData
	local actionType

	if FFlagLuaAppDemoModePlayButtonTelemetry then
		actionType = data.actionType
	end

	v6.actionType = actionType
	gamePlayIntent(eventIngest, v5, v6)
end

return sduiReportGamePlayIntent
