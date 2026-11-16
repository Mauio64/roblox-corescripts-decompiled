local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local Cryo = require(parent.Cryo)
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails
local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local intervalPerformanceTracker = IntervalPerformanceTracker.IntervalPerformanceTracker
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
local UnifiedLogging = require(parent.UnifiedLogging)
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local SduiParsers = SduiCoreSystem.SduiParsers
local SduiErrors = SduiCoreSystem.SduiErrors
local filterAndStringifyAnalyticsData = require(ServerDrivenUi.Analytics.filterAndStringifyAnalyticsData)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableExperienceDetailsBottomSheet = SharedFlags.FFlagEnableExperienceDetailsBottomSheet
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags2.FFlagLuaAppEdpBottomSheetPeekViewEvents
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSduiEdpEnabled = SharedFlags3.FFlagLuaAppSduiEdpEnabled
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiPassSortSubId = SharedFlags4.FFlagLuaAppSduiPassSortSubId
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiFixSearchTelemetry = SharedFlags5.FFlagSduiFixSearchTelemetry
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSduiSponsoredTwoByOneTile = SharedFlags6.FFlagLuaAppSduiSponsoredTwoByOneTile
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiForwardAnalyticsDataToGameClick = SharedFlags7.FFlagSduiForwardAnalyticsDataToGameClick

local v = {}

return function(p, data, p2)
	p2.dependencies.logger.reportCounter(
		SduiErrors.SduiCounterName.OpenGameDetailsAction,
		{
			name = GetInputModeStore(false).getLastInputType(false)
		},
		true
	)

	local actionParams = p and p.actionParams or v
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("itemComponentType", data)

	if analyticsFieldInAncestors == "Tile" or analyticsFieldInAncestors == "GameTile" then
		intervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
	end

	local placeId = actionParams.placeId or findAnalyticsFieldInAncestors("placeId", data)
	local universeId = actionParams.universeId or findAnalyticsFieldInAncestors("universeId", data)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("itemPosition", data)
	local v2

	if FFlagSduiFixSearchTelemetry then
		v2 = findAnalyticsFieldInAncestors("topicDataPosition", data, analyticsFieldInAncestors2)
	else
		v2 = analyticsFieldInAncestors2
	end

	local safeParseBoolean = SduiParsers.safeParseBoolean(
		findAnalyticsFieldInAncestors("adFlag", data, false),
		p2,
		data
	)

	local nativeAdData = findAnalyticsFieldInAncestors("nativeAdData", data)

	if nativeAdData == nil then
		nativeAdData = findAnalyticsFieldInAncestors("adId", data)
	end

	local placeIdOverride, tileType, joined

	if FFlagLuaAppSduiSponsoredTwoByOneTile then
		placeIdOverride = actionParams.placeIdOverride
		tileType = findAnalyticsFieldInAncestors("tileType", data)

		joined = Cryo.Dictionary.join(actionParams.experienceJoinData or v, {
			nativeAdData = nativeAdData,
			tileType = tileType
		})
	end

	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("navigationUniverseId", data, universeId)

	local collectionPosition = nil
	local collectionId = nil
	local totalNumberOfItems = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v3

	if data.getCollectionData then
		v3 = data.getCollectionData() or nil
	end

	if v3 then
		collectionPosition = v3.collectionPosition
		collectionId = v3.collectionId
		totalNumberOfItems = v3.totalNumberOfItems
		itemsPerRow = v3.itemsPerRow
		startRowNumber = v3.startRowNumber
	end

	local v4 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", data)
	local v5 = collectionId or findAnalyticsFieldInAncestors("collectionId", data)
	local v6 = totalNumberOfItems or findAnalyticsFieldInAncestors("totalNumberOfItems", data)
	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("gameSetTargetId", data)
	local analyticsFieldInAncestors5 = findAnalyticsFieldInAncestors("heroUnitId", data)
	local v7 = tonumber(findAnalyticsFieldInAncestors("seeAllFlag", data)) or 0

	local dependencies = p2.dependencies

	if safeParseBoolean and nativeAdData then
		sponsoredGamesRecordClick(dependencies.networking, (tostring(nativeAdData)))
	end

	local v8 = calculateRowPositionFields(analyticsFieldInAncestors2, itemsPerRow, startRowNumber)

	local analyticsFieldInAncestors6 = findAnalyticsFieldInAncestors("appliedFilters", data)
	local v9

	if FFlagLuaAppSduiPassSortSubId then
		v9 = findAnalyticsFieldInAncestors("sortSubId", data)
	end

	local v10

	if FFlagSduiForwardAnalyticsDataToGameClick then
		v10 = filterAndStringifyAnalyticsData(Cryo.Dictionary.join(
			v3 or v,
			data.ancestorAnalyticsData or v,
			data.analyticsData or v
		))
	end

	if actionParams.inheritReferralSession == true then
		local analyticsFieldInAncestors7 = findAnalyticsFieldInAncestors("hostUniverseId", data)
		dependencies.gameAnalytics.reportOpenGameDetailFromGameDetail(
			FFlagLuaAppSduiSponsoredTwoByOneTile and placeIdOverride or placeId,
			analyticsFieldInAncestors2,
			v6,
			safeParseBoolean,
			nativeAdData,
			tostring(universeId),
			p2.appPage,
			analyticsFieldInAncestors7
		)
	else
		local reportOpenGameDetailWithId = dependencies.gameAnalytics.reportOpenGameDetailWithId

		local v11 = tostring(v5)

		local v12 = tostring(universeId)
		local appPage = p2.appPage
		local v13 = tostring(analyticsFieldInAncestors3)

		local positionInRow = v8.positionInRow
		local rowInSort = v8.rowInSort
		local rowOnPage = v8.rowOnPage
		local v14

		if FFlagLuaAppSduiPassSortSubId and v9 then
			v14 = tostring(v9)
		end

		if not FFlagSduiForwardAnalyticsDataToGameClick then
			v10 = nil
		end

		reportOpenGameDetailWithId(
			FFlagLuaAppSduiSponsoredTwoByOneTile and placeIdOverride or placeId,
			v11,
			analyticsFieldInAncestors4,
			v4,
			analyticsFieldInAncestors2,
			v6,
			safeParseBoolean,
			nativeAdData,
			v12,
			appPage,
			v13,
			analyticsFieldInAncestors6,
			v2,
			true,
			positionInRow,
			rowInSort,
			rowOnPage,
			analyticsFieldInAncestors5,
			nil,
			FFlagLuaAppSduiSponsoredTwoByOneTile and tileType or nil,
			v14,
			v10,
			v7
		)
	end

	local navigation = dependencies.getNavigation()
	local dispatch = dependencies.dispatch
	local v11 = tostring(analyticsFieldInAncestors3)

	local v12 = {
		index = analyticsFieldInAncestors2,
		placeIdOverride = FFlagLuaAppSduiSponsoredTwoByOneTile and placeIdOverride or nil,
		experienceJoinData = FFlagLuaAppSduiSponsoredTwoByOneTile and joined or nil,
		mountAsFullView = 0
	}
	local mountAsFullView

	if not (FFlagLuaAppEdpBottomSheetPeekViewEvents or not FFlagEnableExperienceDetailsBottomSheet) then
		mountAsFullView = p2.appPage == AppPage.GameDetail
	end

	v12.mountAsFullView = mountAsFullView
	local v13

	if FFlagLuaAppSduiEdpEnabled then
		v13 = dependencies.networking
	end

	dispatch(OpenGameDetails(v11, navigation, v12, v13))

	p2.dependencies.logger.reportCounter(
		SduiErrors.SduiCounterName.OpenGameDetailsActionFinish,
		{
			name = GetInputModeStore(false).getLastInputType(false)
		},
		true
	)
end
