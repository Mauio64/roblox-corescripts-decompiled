local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local GetInputModeStore = require(Parent.Responsive).GetInputModeStore
local AppPage = require(Parent.RobloxAppEnums).AppPage
local OpenGameDetails = require(Parent.GameDetail).OpenGameDetails
local IntervalPerformanceTracker = require(Parent.IntervalPerformanceTracker).IntervalPerformanceTracker
local sponsoredGamesRecordClick = require(Parent.DiscoveryAnalytics).Requests.sponsoredGamesRecordClick
local calculateRowPositionFields = require(Parent.UnifiedLogging).calculateRowPositionFields
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local SduiParsers = SduiCoreSystem.SduiParsers
local SduiErrors = SduiCoreSystem.SduiErrors
local FFlagEnableExperienceDetailsBottomSheet = require(Parent.SharedFlags).FFlagEnableExperienceDetailsBottomSheet
local FFlagSduiChartsSupport = require(Parent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiEdpPrefetchPlayability = require(Parent.SharedFlags).FFlagSduiEdpPrefetchPlayability
local FFlagLuaAppSduiEdpEnabled = require(Parent.SharedFlags).FFlagLuaAppSduiEdpEnabled
local FFlagSduiEdpInheritGameDetailSourceSession = require(Parent.SharedFlags).FFlagSduiEdpInheritGameDetailSourceSession
local t1 = {}

return function(p1, p2, p3) -- line: 32
	-- upvalues: SduiErrors (copy), GetInputModeStore (copy), t1 (copy), findAnalyticsFieldInAncestors (copy), IntervalPerformanceTracker (copy), SduiParsers (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), FFlagSduiChartsSupport (copy), FFlagSduiEdpInheritGameDetailSourceSession (copy), OpenGameDetails (copy), FFlagEnableExperienceDetailsBottomSheet (copy), AppPage (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy)
	p3.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.OpenGameDetailsAction, {
		name = GetInputModeStore(false).getLastInputType(false)
	}, true)

	local v21 = p1 and p1.actionParams or t1
	local v22 = findAnalyticsFieldInAncestors("itemComponentType", p2)

	if v22 == "Tile" or v22 == "GameTile" then
		IntervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
	end

	local v23 = v21.placeId or findAnalyticsFieldInAncestors("placeId", p2)
	local v24 = v21.universeId or findAnalyticsFieldInAncestors("universeId", p2)
	local v25 = findAnalyticsFieldInAncestors("itemPosition", p2)
	local v26 = SduiParsers.safeParseBoolean(findAnalyticsFieldInAncestors("adFlag", p2, false), p3, p2)
	local v27 = findAnalyticsFieldInAncestors("nativeAdData", p2)

	if v27 == nil then
		v27 = findAnalyticsFieldInAncestors("adId", p2)
	end

	local v28 = findAnalyticsFieldInAncestors("navigationUniverseId", p2, v24)
	local collectionPosition = nil
	local collectionId = nil
	local totalNumberOfItems = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v34 = p2.getCollectionData and p2.getCollectionData() or nil

	if v34 then
		collectionPosition = v34.collectionPosition
		collectionId = v34.collectionId
		totalNumberOfItems = v34.totalNumberOfItems
		itemsPerRow = v34.itemsPerRow
		startRowNumber = v34.startRowNumber
	end

	local v35 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", p2)
	local v36 = collectionId or findAnalyticsFieldInAncestors("collectionId", p2)
	local v37 = totalNumberOfItems or findAnalyticsFieldInAncestors("totalNumberOfItems", p2)
	local v38 = findAnalyticsFieldInAncestors("gameSetTargetId", p2)
	local v39 = findAnalyticsFieldInAncestors("heroUnitId", p2)
	local dependencies = p3.dependencies

	if v26 and v27 then
		sponsoredGamesRecordClick(dependencies.networking, (tostring(v27)))
	end

	local v41 = calculateRowPositionFields(v25, itemsPerRow, startRowNumber)
	local v42 = nil

	if FFlagSduiChartsSupport then
		v42 = findAnalyticsFieldInAncestors("appliedFilters", p2)
	end

	if FFlagSduiEdpInheritGameDetailSourceSession and v21.inheritReferralSession == true then
		local v43 = findAnalyticsFieldInAncestors("hostUniverseId", p2)

		dependencies.gameAnalytics.reportOpenGameDetailFromGameDetail(v23, v25, v37, v26, v27, tostring(v24), p3.appPage, v43)
	else
		dependencies.gameAnalytics.reportOpenGameDetailWithId(v23, tostring(v36), v38, v35, v25, v37, v26, v27, tostring(v24), p3.appPage, tostring(v28), v42, v25, true, v41.positionInRow, v41.rowInSort, v41.rowOnPage, v39)
	end

	local v44 = dependencies.getNavigation()

	dependencies.dispatch(OpenGameDetails(tostring(v28), v44, {
		index = v25,
		mountAsFullView = if not FFlagEnableExperienceDetailsBottomSheet then nil else p3.appPage == AppPage.GameDetail
	}, if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else dependencies.networking))
	p3.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.OpenGameDetailsActionFinish, {
		name = GetInputModeStore(false).getLastInputType(false)
	}, true)
end
