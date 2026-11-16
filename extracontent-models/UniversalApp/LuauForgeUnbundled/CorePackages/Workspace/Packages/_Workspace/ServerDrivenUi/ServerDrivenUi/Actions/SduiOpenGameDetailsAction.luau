local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local getInputModeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive").GetInputModeStore

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameDetail").OpenGameDetails
local intervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/IntervalPerformanceTracker").IntervalPerformanceTracker
local sponsoredGamesRecordClick = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Requests.sponsoredGamesRecordClick
local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UnifiedLogging").calculateRowPositionFields

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local sduiParsers = SduiCoreSystem.SduiParsers
local sduiErrors = SduiCoreSystem.SduiErrors
local filterAndStringifyAnalyticsData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/filterAndStringifyAnalyticsData")

local fFlagEnableExperienceDetailsBottomSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagEnableExperienceDetailsBottomSheet
local fFlagLuaAppEdpBottomSheetPeekViewEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppEdpBottomSheetPeekViewEvents
local fFlagLuaAppSduiEdpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiEdpEnabled
local fFlagLuaAppSduiPassSortSubId = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiPassSortSubId
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiFixSearchTelemetry
local fFlagLuaAppSduiSponsoredTwoByOneTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiSponsoredTwoByOneTile
local fFlagSduiForwardAnalyticsDataToGameClick = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiForwardAnalyticsDataToGameClick

local v5 = {}

return function(p2, data, p3)
	p3.dependencies.logger.reportCounter(
		sduiErrors.SduiCounterName.OpenGameDetailsAction,
		{
			name = getInputModeStore(false).getLastInputType(false)
		},
		true
	)

	local actionParams = p2 and p2.actionParams or v5
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("itemComponentType", data)

	if analyticsFieldInAncestors == "Tile" or analyticsFieldInAncestors == "GameTile" then
		intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
	end

	local placeId = actionParams.placeId or findAnalyticsFieldInAncestors("placeId", data)
	local universeId = actionParams.universeId or findAnalyticsFieldInAncestors("universeId", data)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("itemPosition", data)
	local v6

	if fFlagSduiFixSearchTelemetry then
		v6 = findAnalyticsFieldInAncestors("topicDataPosition", data, analyticsFieldInAncestors2)
	else
		v6 = analyticsFieldInAncestors2
	end

	local safeParseBoolean = sduiParsers.safeParseBoolean(
		findAnalyticsFieldInAncestors("adFlag", data, false),
		p3,
		data
	)

	local v7 = findAnalyticsFieldInAncestors("nativeAdData", data)

	if v7 == nil then
		v7 = findAnalyticsFieldInAncestors("adId", data)
	end

	local placeIdOverride, v8, joined

	if fFlagLuaAppSduiSponsoredTwoByOneTile then
		placeIdOverride = actionParams.placeIdOverride
		v8 = findAnalyticsFieldInAncestors("tileType", data)

		joined = Cryo.Dictionary.join(actionParams.experienceJoinData or v5, {
			nativeAdData = v7,
			tileType = v8
		})
	end

	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors(
		"navigationUniverseId",
		data,
		universeId
	)

	local collectionPosition = nil
	local collectionId = nil
	local totalNumberOfItems = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v9 = if data.getCollectionData then data.getCollectionData() or nil else nil

	if v9 then
		collectionPosition = v9.collectionPosition
		collectionId = v9.collectionId
		totalNumberOfItems = v9.totalNumberOfItems
		itemsPerRow = v9.itemsPerRow
		startRowNumber = v9.startRowNumber
	end

	local v10 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", data)
	local v11 = collectionId or findAnalyticsFieldInAncestors("collectionId", data)
	local v12 = totalNumberOfItems or findAnalyticsFieldInAncestors("totalNumberOfItems", data)
	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("gameSetTargetId", data)
	local analyticsFieldInAncestors5 = findAnalyticsFieldInAncestors("heroUnitId", data)
	local v13 = tonumber(findAnalyticsFieldInAncestors("seeAllFlag", data)) or 0

	local dependencies = p3.dependencies

	if safeParseBoolean and v7 then
		sponsoredGamesRecordClick(dependencies.networking, (tostring(v7)))
	end

	local v14 = calculateRowPositionFields(analyticsFieldInAncestors2, itemsPerRow, startRowNumber)

	local analyticsFieldInAncestors6 = findAnalyticsFieldInAncestors("appliedFilters", data)
	local v15

	if fFlagLuaAppSduiPassSortSubId then
		v15 = findAnalyticsFieldInAncestors("sortSubId", data)
	end

	local v16

	if fFlagSduiForwardAnalyticsDataToGameClick then
		v16 = filterAndStringifyAnalyticsData(Cryo.Dictionary.join(
			v9 or v5,
			data.ancestorAnalyticsData or v5,
			data.analyticsData or v5
		))
	end

	if actionParams.inheritReferralSession == true then
		local analyticsFieldInAncestors7 = findAnalyticsFieldInAncestors("hostUniverseId", data)
		dependencies.gameAnalytics.reportOpenGameDetailFromGameDetail(
			fFlagLuaAppSduiSponsoredTwoByOneTile and placeIdOverride or placeId,
			analyticsFieldInAncestors2,
			v12,
			safeParseBoolean,
			v7,
			tostring(universeId),
			p3.appPage,
			analyticsFieldInAncestors7
		)
	else
		local reportOpenGameDetailWithId = dependencies.gameAnalytics.reportOpenGameDetailWithId

		local v18 = tostring(v11)

		local v19 = tostring(universeId)
		local appPage2 = p3.appPage
		local v20 = tostring(analyticsFieldInAncestors3)

		local positionInRow = v14.positionInRow
		local rowInSort = v14.rowInSort
		local rowOnPage = v14.rowOnPage

		local v24 = if fFlagLuaAppSduiPassSortSubId and v15 then tostring(v15) else nil

		if not fFlagSduiForwardAnalyticsDataToGameClick then
			v16 = nil
		end

		reportOpenGameDetailWithId(
			fFlagLuaAppSduiSponsoredTwoByOneTile and placeIdOverride or placeId,
			v18,
			analyticsFieldInAncestors4,
			v10,
			analyticsFieldInAncestors2,
			v12,
			safeParseBoolean,
			v7,
			v19,
			appPage2,
			v20,
			analyticsFieldInAncestors6,
			v6,
			true,
			positionInRow,
			rowInSort,
			rowOnPage,
			analyticsFieldInAncestors5,
			nil,
			fFlagLuaAppSduiSponsoredTwoByOneTile and v8 or nil,
			v24,
			v16,
			v13
		)
	end

	local navigation = dependencies.getNavigation()
	local dispatch = dependencies.dispatch
	local v18 = tostring(analyticsFieldInAncestors3)

	local v19 = {
		index = analyticsFieldInAncestors2,
		placeIdOverride = fFlagLuaAppSduiSponsoredTwoByOneTile and placeIdOverride or nil,
		experienceJoinData = fFlagLuaAppSduiSponsoredTwoByOneTile and joined or nil,
		mountAsFullView = 0
	}

	local v20 = if not (fFlagLuaAppEdpBottomSheetPeekViewEvents or not fFlagEnableExperienceDetailsBottomSheet) then p3.appPage == appPage.GameDetail else nil
	v19.mountAsFullView = v20

	local v21 = if fFlagLuaAppSduiEdpEnabled then dependencies.networking else nil
	dispatch(openGameDetails(v18, navigation, v19, v21))

	p3.dependencies.logger.reportCounter(
		sduiErrors.SduiCounterName.OpenGameDetailsActionFinish,
		{
			name = getInputModeStore(false).getLastInputType(false)
		},
		true
	)
end
