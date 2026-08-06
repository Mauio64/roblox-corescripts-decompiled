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
local FFlagLuaAppAddSeeAllFlagToGameDetailReferral = require(Parent.SharedFlags).FFlagLuaAppAddSeeAllFlagToGameDetailReferral
local t1 = {}

return function(p1, p2, p3) -- line: 34
	-- upvalues: SduiErrors (copy), GetInputModeStore (copy), t1 (copy), findAnalyticsFieldInAncestors (copy), IntervalPerformanceTracker (copy), SduiParsers (copy), FFlagLuaAppAddSeeAllFlagToGameDetailReferral (copy), sponsoredGamesRecordClick (copy), calculateRowPositionFields (copy), FFlagSduiChartsSupport (copy), FFlagSduiEdpInheritGameDetailSourceSession (copy), OpenGameDetails (copy), FFlagEnableExperienceDetailsBottomSheet (copy), AppPage (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy)
	p3.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.OpenGameDetailsAction, {
		name = GetInputModeStore(false).getLastInputType(false)
	}, true)

	local v22 = p1 and p1.actionParams or t1
	local v23 = findAnalyticsFieldInAncestors("itemComponentType", p2)

	if v23 == "Tile" or v23 == "GameTile" then
		IntervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
	end

	local v24 = v22.placeId or findAnalyticsFieldInAncestors("placeId", p2)
	local v25 = v22.universeId or findAnalyticsFieldInAncestors("universeId", p2)
	local v26 = findAnalyticsFieldInAncestors("itemPosition", p2)
	local v27 = SduiParsers.safeParseBoolean(findAnalyticsFieldInAncestors("adFlag", p2, false), p3, p2)
	local v28 = findAnalyticsFieldInAncestors("nativeAdData", p2)

	if v28 == nil then
		v28 = findAnalyticsFieldInAncestors("adId", p2)
	end

	local v29 = findAnalyticsFieldInAncestors("navigationUniverseId", p2, v25)
	local collectionPosition = nil
	local collectionId = nil
	local totalNumberOfItems = nil
	local itemsPerRow = nil
	local startRowNumber = nil
	local v35 = p2.getCollectionData and p2.getCollectionData() or nil

	if v35 then
		collectionPosition = v35.collectionPosition
		collectionId = v35.collectionId
		totalNumberOfItems = v35.totalNumberOfItems
		itemsPerRow = v35.itemsPerRow
		startRowNumber = v35.startRowNumber
	end

	local v36 = collectionPosition or findAnalyticsFieldInAncestors("collectionIndex", p2)
	local v37 = collectionId or findAnalyticsFieldInAncestors("collectionId", p2)
	local v38 = totalNumberOfItems or findAnalyticsFieldInAncestors("totalNumberOfItems", p2)
	local v39 = findAnalyticsFieldInAncestors("gameSetTargetId", p2)
	local v40 = findAnalyticsFieldInAncestors("heroUnitId", p2)
	local v41 = if not FFlagLuaAppAddSeeAllFlagToGameDetailReferral then nil else tonumber(findAnalyticsFieldInAncestors("seeAllFlag", p2)) or 0
	local dependencies = p3.dependencies

	if v27 and v28 then
		sponsoredGamesRecordClick(dependencies.networking, (tostring(v28)))
	end

	local v43 = calculateRowPositionFields(v26, itemsPerRow, startRowNumber)
	local v44 = nil

	if FFlagSduiChartsSupport then
		v44 = findAnalyticsFieldInAncestors("appliedFilters", p2)
	end

	if FFlagSduiEdpInheritGameDetailSourceSession and v22.inheritReferralSession == true then
		local v45 = findAnalyticsFieldInAncestors("hostUniverseId", p2)

		dependencies.gameAnalytics.reportOpenGameDetailFromGameDetail(v24, v26, v38, v27, v28, tostring(v25), p3.appPage, v45)
	else
		dependencies.gameAnalytics.reportOpenGameDetailWithId(v24, tostring(v37), v39, v36, v26, v38, v27, v28, tostring(v25), p3.appPage, tostring(v29), v44, v26, true, v43.positionInRow, v43.rowInSort, v43.rowOnPage, v40, nil, nil, nil, nil, if not FFlagLuaAppAddSeeAllFlagToGameDetailReferral then nil else v41)
	end

	local v46 = dependencies.getNavigation()

	dependencies.dispatch(OpenGameDetails(tostring(v29), v46, {
		index = v26,
		mountAsFullView = if not FFlagEnableExperienceDetailsBottomSheet then nil else p3.appPage == AppPage.GameDetail
	}, if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else dependencies.networking))
	p3.dependencies.logger.reportCounter(SduiErrors.SduiCounterName.OpenGameDetailsActionFinish, {
		name = GetInputModeStore(false).getLastInputType(false)
	}, true)
end
