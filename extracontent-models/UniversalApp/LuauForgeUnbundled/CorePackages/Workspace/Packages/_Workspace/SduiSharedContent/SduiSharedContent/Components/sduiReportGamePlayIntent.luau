local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UnifiedLogging").calculateRowPositionFields

local setGamePlaySession = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppSessionization").SetGamePlaySession

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics")
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick

local findAnalyticsFieldInAncestors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem").findAnalyticsFieldInAncestors

local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry

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
	local v5

	if analyticsContext.getCollectionData then
		v5 = analyticsContext.getCollectionData() or nil
	end

	if v5 then
		collectionPosition = v5.collectionPosition
		collectionId = v5.collectionId
		itemsPerRow = v5.itemsPerRow
		startRowNumber = v5.startRowNumber
	end

	local v6 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", analyticsContext)
	local v7 = collectionId or findAnalyticsFieldInAncestors("collectionId", analyticsContext)
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("gameSetTargetId", analyticsContext)

	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("itemPosition", analyticsContext, -1)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors(
		"topicDataPosition",
		analyticsContext,
		analyticsFieldInAncestors2
	)

	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("heroUnitId", analyticsContext)

	local analyticsFieldInAncestors5 = findAnalyticsFieldInAncestors(
		"eventContext",
		analyticsContext,
		"ExperienceTile"
	)
	local analyticsFieldInAncestors6 = findAnalyticsFieldInAncestors("referralSource", analyticsContext)

	local analyticsFieldInAncestors7 = findAnalyticsFieldInAncestors(
		"gamePlaySessionType",
		analyticsContext
	)

	if analyticsFieldInAncestors7 then
		setGamePlaySession(sessionService, analyticsFieldInAncestors7, true)
	end

	local v8 = findAnalyticsFieldInAncestors("nativeAdData", analyticsContext)

	if v8 == nil then
		v8 = findAnalyticsFieldInAncestors("adId", analyticsContext)
	end

	if v8 then
		sponsoredGamesRecordClick(sduiContext.dependencies.networking, (tostring(v8)))
	end

	local v9 = (typeof(analyticsFieldInAncestors2) ~= "number" or (typeof)(itemsPerRow) ~= "number" or (typeof)(startRowNumber) ~= "number" or analyticsFieldInAncestors2 == -1 or itemsPerRow == -1 or startRowNumber == -1)
		and {}
		or calculateRowPositionFields(analyticsFieldInAncestors2, itemsPerRow, startRowNumber)

	local analyticsFieldInAncestors8 = findAnalyticsFieldInAncestors(
		"tileType",
		analyticsContext,
		"GameTile"
	)

	local v11 = tostring(analyticsFieldInAncestors5)
	local v12 = {
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
	local v13 = if v6 then tostring(v6) else nil
	v12.sortIndex = v13
	local v14 = if typeof(analyticsFieldInAncestors2) == "number" and analyticsFieldInAncestors2 ~= -1 then tostring(analyticsFieldInAncestors2) else nil
	v12.sortEntryIndex = v14

	v12.referralSource = analyticsFieldInAncestors6
	local v15 = if v7 then tostring(v7) else nil
	v12.gameSetTypeId = v15
	v12.gameSetTargetId = analyticsFieldInAncestors
	v12.appliedFilters = appliedFilters

	if
		typeof(analyticsFieldInAncestors3) ~= "number"
		or analyticsFieldInAncestors3 == -1
		or not analyticsFieldInAncestors3
	then
		analyticsFieldInAncestors3 = nil
	end

	v12.topicDataPosition = analyticsFieldInAncestors3

	v12.nativeAdData = v8
	v12.pageName = sduiContext.appPage
	v12.positionInRow = v9.positionInRow
	v12.rowNumber = v9.rowInSort
	v12.feedRowNumber = v9.rowOnPage
	v12.heroUnitId = analyticsFieldInAncestors4
	v12.tileType = analyticsFieldInAncestors8
	v12.launchData = launchData
	local v16 = if fFlagLuaAppDemoModePlayButtonTelemetry then data.actionType else nil
	v12.actionType = v16
	gamePlayIntent(eventIngest, v11, v12)
end

return sduiReportGamePlayIntent
