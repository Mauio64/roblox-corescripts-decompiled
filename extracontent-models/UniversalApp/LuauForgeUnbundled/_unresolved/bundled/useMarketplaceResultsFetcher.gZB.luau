local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
require("@luauforge/bundled/dKT")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useStore
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/egx")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/gZC")
local module3 = require("@luauforge/bundled/dVl")
local module4 = require("@luauforge/bundled/dPU")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module5 = require("@luauforge/bundled/gZE")

local module6 = require("@luauforge/bundled/gZF")

local module7 = require("@luauforge/bundled/gZG")

local module8 = require("@luauforge/bundled/gZH")

local module9 = require("@luauforge/bundled/dPN")

local axPrefetchMarketplaceIXP = require("@luauforge/bundled/gZJ").AXPrefetchMarketplaceIXP
local module10 = require("@luauforge/bundled/dPR")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local module12 = require("@luauforge/bundled/fCe")

local module13 = require("@luauforge/bundled/gZP")
local module14 = require("@luauforge/bundled/gZX")

local getSearchKeywordFromSearchesParameters = module14.getSearchKeywordFromSearchesParameters

local getShouldFetchCatalogOrganicAfterWidgets = module14.getShouldFetchCatalogOrganicAfterWidgets
local module15 = require("@luauforge/bundled/gZY")
local module16 = require("@luauforge/bundled/gZW")
local module17 = require("@luauforge/bundled/gZR")
local module18 = require("@luauforge/bundled/dSV")
local module19 = require("@luauforge/bundled/dSW")
local module20 = require("@luauforge/bundled/dFs")

local module21 = require("@luauforge/bundled/hae")
local module22 = require("@luauforge/bundled/dQX")
local module23 = require("@luauforge/bundled/fwS")
local module24 = require("@luauforge/bundled/fwR")
local module25 = require("@luauforge/bundled/gZU")
local module26 = require("@luauforge/bundled/dWq")
require("@luauforge/bundled/dVO")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash
local fFlagAXUnifiedMarketplaceResultsFetcher = AvatarExperienceFlags.FFlagAXUnifiedMarketplaceResultsFetcher
local fFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter
local fFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local fFlagAXResetFetchMarketplaceLogic = AvatarExperienceFlags.FFlagAXResetFetchMarketplaceLogic
local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXFixHydratedWidgetsParams = AvatarExperienceFlags.FFlagAXFixHydratedWidgetsParams
local fFlagAXFixDataProcessingMilestoneGating = AvatarExperienceFlags.FFlagAXFixDataProcessingMilestoneGating
local module28 = require("@luauforge/bundled/gLF")
local ttiPerformanceManager = module28.TTIPerformanceManager
local widgetsPercievedTTIManager = module28.WidgetsPercievedTTIManager
local organicTTIMilestoneManager = module28.OrganicTTIMilestoneManager
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

function LUAUFORGE_MODULE_GLOBALS_gZB_selectSortAndFilters(p2)
	if
		fFlagAXFixPrefetchMarketplaceStartupCrash
		and not (p2.AvatarExperience and p2.AvatarExperience.Catalog)
	then
		return nil
	end

	return p2.AvatarExperience.Catalog.SortAndFilters
end

local function useMarketplaceResultsFetcher(data)
	local v5

	if axPrefetchMarketplaceIXP.isEnabled() then
		v5 = module10.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
	end

	local v6 = useDispatch()
	local v7

	if fFlagAXResetFetchMarketplaceLogic then
		v7 = useSelector(LUAUFORGE_MODULE_GLOBALS_gZB_selectSortAndFilters)
	else
		v7 = nil
	end

	local v8 = if fFlagAXResetFetchMarketplaceLogic then React.useContext(module5.Consumer) else nil

	local v9 = useRoactService(module)

	local fetchMarketplaceStore = module2.getFetchMarketplaceStore(false)
	local v10 = useSignalState(fetchMarketplaceStore.getFetchingMarketplace)
	local v11 = useSignalState(fetchMarketplaceStore.getFetchedMarketplace)
	local v12

	if fFlagAXPrefetchOnlyWithinTTL then
		v12 = useSignalState(fetchMarketplaceStore.getFetchedMarketplaceTimestamp)
	end

	local setFetchingMarketplaceInProgress = fetchMarketplaceStore.setFetchingMarketplaceInProgress
	local setFetchedMarketplaceCompleted = fetchMarketplaceStore.setFetchedMarketplaceCompleted
	local setFetchingMarketplaceErrorOccured

	if fFlagAXMoveAllTabToWidgetOnly or fFlagAXCatalogCategoriesSDUI then
		setFetchingMarketplaceErrorOccured = fetchMarketplaceStore.setFetchingMarketplaceErrorOccured
	else
		setFetchingMarketplaceErrorOccured = nil
	end

	local setCatalogCategoriesErrorOccured

	if fFlagAXCatalogCategoriesSDUI then
		setCatalogCategoriesErrorOccured = fetchMarketplaceStore.setCatalogCategoriesErrorOccured
	else
		setCatalogCategoriesErrorOccured = nil
	end

	local setFetchingMarketplaceProcessed

	if fFlagAXMoveAllTabToWidgetOnly then
		setFetchingMarketplaceProcessed = fetchMarketplaceStore.setFetchingMarketplaceProcessed
	else
		setFetchingMarketplaceProcessed = nil
	end

	local v13 = module6()

	local v14, v15 = module7()
	local v16 = v14 or module9.DefaultCatalogCategoryId

	local v17 = if data and not fFlagAXFixHydratedWidgetsParams then data.categoryInfo else v13

	if data then
		v16 = data.categoryId
	end

	if data then
		v15 = data.subcategoryId
	end

	local flag = false

	if fFlagAXMigrateAllTabToSduiDev then
		local v18 = useSignalState(module19.getCatalogCategoriesStore().getCategoriesMap)

		v17 = module12.getCategoryInfoById(v18, v16, v15)

		if not v17 then
			v17 = v13
			flag = true
		end
	elseif fFlagAXFixHydratedWidgetsParams then
		local v18 = module18()

		v17 = module12.getCategoryInfoById(v18, v16, v15)

		if not v17 then
			module20("[useMarketplaceResultsFetcher] categoryInfo is nil for categoryId: " .. tostring(v16) .. " and subcategoryId: " .. tostring(v15))
			v17 = v13
		end
	end

	if fFlagAXMigrateAllTabToSduiDev then
		React.useEffect(function()
			if flag then
				sendAXCounterV2(module9.Counter.Errors.FetcherCategoryInfoMissing)
			end
		end, { flag, v16, v15 })
	end

	local ref = if fFlagAXMigrateAllTabToSduiDev then React.useRef(false) else nil

	local searchUuid = if data then data.searchUuid else v17.SearchUuid
	local v18 = useStore()

	local state, setState = React.useState(false)
	local state2, setState2, state3, setState3, state4, setState4, state5, setState5, state6, setState6

	if fFlagAXMoveAllTabToWidgetOnly then
		state2, setState2 = React.useState(false)
		state3, setState3 = React.useState(false)
		state4, setState4 = React.useState(false)
		state5, setState5 = React.useState(false)
		state6, setState6 = React.useState(false)
	else
		setState2 = nil
		setState3 = nil
		setState4 = nil
		setState5 = nil
		setState6 = nil
		state2 = nil
		state3 = nil
		state6 = nil
		state4 = nil
		state5 = nil
	end

	local state7, setState7 = React.useState(false)
	local v19 = (v5 or fFlagAXUnifiedMarketplaceResultsFetcher) and not v10 and searchUuid ~= nil

	if fFlagAXMigrateAllTabToSduiDev and flag then
		v19 = false
	end

	local v20 = if fFlagAXCatalogCategoriesSDUI then module8() else nil
	local v21

	if fFlagAXResetFetchMarketplaceLogic then
		v21 = React.useCallback(function()
			if fFlagAXFixPrefetchMarketplaceStartupCrash and v7 == nil then
				return
			end

			if fFlagAXMoveAllTabToWidgetOnly then
				setState2(false)
				setState3(false)
				setState4(false)
				setState5(false)
				setState6(false)
			else
				setState(false)
			end

			setState7(false)

			if v8 then
				v8:storePageObject(searchUuid, nil)
			end

			v6(module21(searchUuid))

			ttiPerformanceManager.Surface.Marketplace.Root.startTracking()
			v6(module26.StartTracking(searchUuid))

			v6(module24(searchUuid, RobloxAppEnums.SearchTypes.Catalog))

			local searchKeyword = nil
			local state8 = v18:getState()
			local v22

			if state8.SearchesParameters and searchUuid then
				v22 = state8.SearchesParameters[searchUuid]
			end

			if v22 then
				searchKeyword = v22.searchKeyword
			end

			local v26 = {
				categoryInfo = v17,
				catalogSort = v7.CatalogSort,
				catalogSortAggregation = v7.CatalogSortAggregation,
				minPrice = v7.PriceRange.minPrice,
				maxPrice = v7.PriceRange.maxPrice,
				selectedTopics = v7.SelectedTopics,
				creatorFilter = v7.CreatorFilter,
				salesTypeFilter = v7.SalesTypeFilter,
				unavailableItemFilter = v7.UnavailableItemFilter,
				wearTimeFilter = v7.WearTimeFilter,
				specialFeaturesFilter = 0,
				searchKeyword = 0
			}

			local v27 = if fFlagAXCatalogSpecialFeaturesFilter then v7.SpecialFeaturesFilter else nil
			v26.specialFeaturesFilter = v27

			v26.searchKeyword = searchKeyword
			v6(module23(searchUuid, v26))

			local v28 = nil
			local v29 = v16
			local v30 = v15

			if v29 then
				if type(v29) ~= "string" then
					v29 = if type(v29) == "number" then tostring(v29) else nil
				end

				if type(v30) ~= "string" then
					v30 = if type(v30) == "number" then tostring(v30) else nil
				end

				if v29 then
					v28 = module3.getContextForWidgetsById(avatarScreen.Catalog, v29, v30)
				end
			end

			if v28 then
				v6(module22(nil, v28))
			end

			v6(module22(nil, nil))

			setFetchingMarketplaceInProgress()
		end, {
			v8,
			searchUuid,
			v7,
			v17,
			v16,
			v15,
			setFetchingMarketplaceInProgress,
			v18,
			v6
		})
	else
		v21 = nil
	end

	local v22

	if fFlagAXMoveAllTabToWidgetOnly then
		v22 = React.useCallback(function()
			if not v17.ShowSponsored then
				setState5(true)

				return
			end

			local v23 = v6(module16(
				v9,
				module4.SponsoredItemsCategoryRecommended,
				module4.SponsoredItemsToFetch
			))

			if v23 and v23.andThen then
				v23:andThen(function()
					setState3(true)
					setState5(true)
				end, function(p2)
					logging.warn("useMarketplaceResultsFetcher: Fetch sponsored items failed: " .. tostring(p2))
					setState5(true)
				end)
			else
				setState5(true)
			end
		end, { v17, v9, v6, setState3, setState5 })
	else
		v22 = nil
	end

	local v23

	if fFlagAXMoveAllTabToWidgetOnly then
		v23 = React.useCallback(function()
			local v24 = {
				searchUuid = searchUuid,
				categoryInfo = v17,
				recordSearchTime = true
			}

			local searchKeywordFromSearchesParameters = getSearchKeywordFromSearchesParameters(v18, searchUuid)

			if searchKeywordFromSearchesParameters then
				v24.searchKeyword = searchKeywordFromSearchesParameters
			end

			local v25 = v6(module17(v24, v9))

			if v25 and v25.andThen then
				v25:andThen(function()
					setState2(true)
					setState4(true)
					widgetsPercievedTTIManager.L3.requestFetchCatalogSearchOrganic()
				end, function(p2)
					logging.warn("useMarketplaceResultsFetcher: Fetch catalog search failed: " .. tostring(p2))
					setState4(true)
				end)
			else
				setState4(true)
			end
		end, { searchUuid, v17, v6, v9, setState2, setState4, v18 })
	else
		v23 = nil
	end

	local v24

	if fFlagAXMoveAllTabToWidgetOnly then
		v24 = React.useCallback(function()
			v6(module25(searchUuid, tick()))
		end, { v6, searchUuid })
	else
		v24 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if fFlagAXMigrateAllTabToSduiDev and flag then
			ref.current = true
			return
		end

		if not v19 then
			return
		end

		if fFlagAXMigrateAllTabToSduiDev then
			ref.current = false
		end

		widgetsPercievedTTIManager.L2.primaryDataStarted()
		organicTTIMilestoneManager.L2.primaryDataStarted()

		if fFlagAXResetFetchMarketplaceLogic then
			v21()
		else
			setFetchingMarketplaceInProgress()
		end

		if fFlagAXMoveAllTabToWidgetOnly then
			v24()

			if fFlagAXCatalogCategoriesSDUI and not fFlagAXMigrateAllTabToSduiDev then
				v20():andThen(function() end, function(p2)
					warn("fetchCatalogCategories error", p2)
					local success, result = pcall(function()
						return (string.sub(tostring(p2), 1, 100))
					end)

					sendAXCounterV2(module9.Counter.Catalog.Errors.FetchCatalogCategoriesError, {
						error = not success and "unknown" or result
					})

					setCatalogCategoriesErrorOccured()
				end)
			end

			widgetsPercievedTTIManager.L3.networkFetch()
			organicTTIMilestoneManager.L3.networkFetch()
			local v30 = if fFlagAXFixHydratedWidgetsParams then v16 else nil
			local v31 = if fFlagAXFixHydratedWidgetsParams then v15 else nil
			local v32 = module15(v6, v9, v17, v18, v30, v31)

			v22()

			if v32 and v32.andThen then
				v32:andThen(function(p2)
					setState7(true)
					setState6(true)

					local disableOrganicContentFetch = p2
						and p2.configuration
						and p2.configuration.customizedDataMap
						and p2.configuration.customizedDataMap.disableOrganicContentFetch

					if getShouldFetchCatalogOrganicAfterWidgets(
						disableOrganicContentFetch,
						(getSearchKeywordFromSearchesParameters(v18, searchUuid))
					) then
						v23()
					else
						setState4(true)
					end
				end, function(p2)
					setState4(true)
					setFetchingMarketplaceErrorOccured()
				end)
			end
		else
			if fFlagAXCatalogCategoriesSDUI and not fFlagAXMigrateAllTabToSduiDev then
				v20():andThen(function() end, function(p2)
					warn("fetchCatalogCategories error", p2)
					local success, result = pcall(function()
						return (string.sub(tostring(p2), 1, 100))
					end)

					sendAXCounterV2(module9.Counter.Catalog.Errors.FetchCatalogCategoriesError, {
						error = not success and "unknown" or result
					})

					setCatalogCategoriesErrorOccured()
				end)
			end

			widgetsPercievedTTIManager.L3.networkFetch()
			organicTTIMilestoneManager.L3.networkFetch()

			local v25 = module13(
				v6,
				v9,
				searchUuid,
				v17,
				getSearchKeywordFromSearchesParameters(v18, searchUuid)
			)
			local v31 = if fFlagAXFixHydratedWidgetsParams then v16 else nil
			local v32 = if fFlagAXFixHydratedWidgetsParams then v15 else nil
			local v33 = module15(v6, v9, v17, v18, v31, v32)

			if v25 and v25.andThen then
				v25:andThen(function()
					setState(true)
					widgetsPercievedTTIManager.L3.requestFetchCatalogSearch()
				end)
			end

			if v33 and v33.andThen then
				v33:andThen(function()
					setState7(true)
				end)
			end
		end
	end

	local v27 = if fFlagAXMigrateAllTabToSduiDev then flag else nil
	local v28 = if fFlagAXResetFetchMarketplaceLogic then v21 else nil
	local v30 = if fFlagAXFixHydratedWidgetsParams then v16 else nil
	local v31 = if fFlagAXFixHydratedWidgetsParams then v15 else nil
	local v32 = if fFlagAXMoveAllTabToWidgetOnly then setState2 else nil
	local v33 = if fFlagAXMoveAllTabToWidgetOnly then v24 else nil
	local v34 = if fFlagAXMoveAllTabToWidgetOnly then setState6 else nil
	local v25 = {
		v19,
		v27,
		searchUuid,
		setFetchingMarketplaceInProgress,
		v6,
		v28,
		v9,
		v17,
		v30,
		v31,
		v18,
		setState,
		v32,
		v33,
		v34,
		if fFlagAXMoveAllTabToWidgetOnly then setState4 else nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local v36 = if fFlagAXMoveAllTabToWidgetOnly then setFetchingMarketplaceErrorOccured else nil
	local v37 = if fFlagAXMigrateAllTabToSduiDev then v20 else nil
	local v38 = if fFlagAXMigrateAllTabToSduiDev then v23 else nil
	local v39 = if fFlagAXMigrateAllTabToSduiDev then v22 else nil
	v25[17], v25[18], v25[19], v25[20], v25[21], v25[22] = v36, setState7, v37, v38, v39, if fFlagAXMigrateAllTabToSduiDev then setCatalogCategoriesErrorOccured else nil
	local v41 = useCallback(fn, v25)

	if fFlagAXMigrateAllTabToSduiDev then
		React.useEffect(function()
			if not flag and ref.current then
				v41()
			end
		end, { flag, v41 })
	end

	if fFlagAXMoveAllTabToWidgetOnly then
		local useEffect = React.useEffect
		local function fn2()
			if state7 and state2 and state3 then
				if not fFlagAXFixDataProcessingMilestoneGating then
					widgetsPercievedTTIManager.L2.dataProcessingStarted()
					organicTTIMilestoneManager.L2.dataProcessingStarted()
				end

				setFetchedMarketplaceCompleted()

				if not fFlagAXFixDataProcessingMilestoneGating then
					widgetsPercievedTTIManager.L2.dataProcessingCompleted()
					organicTTIMilestoneManager.L2.dataProcessingCompleted()
				end
			end

			if state6 and state4 and state5 then
				if fFlagAXFixDataProcessingMilestoneGating then
					widgetsPercievedTTIManager.L2.dataProcessingStarted()
					organicTTIMilestoneManager.L2.dataProcessingStarted()
				end

				setFetchingMarketplaceProcessed()

				if fFlagAXFixDataProcessingMilestoneGating then
					widgetsPercievedTTIManager.L2.dataProcessingCompleted()
					organicTTIMilestoneManager.L2.dataProcessingCompleted()
				end
			end
		end

		local v48 = if fFlagAXMigrateAllTabToSduiDev then setFetchedMarketplaceCompleted else nil
		useEffect(fn2, {
			state7,
			state2,
			state3,
			state6,
			state4,
			state5,
			v48,
			if fFlagAXMigrateAllTabToSduiDev then setFetchingMarketplaceProcessed else nil
		})
	else
		local function fn2()
			if state and state7 then
				widgetsPercievedTTIManager.L3.responseReceived()
				widgetsPercievedTTIManager.L2.dataProcessingStarted()
				organicTTIMilestoneManager.L3.responseReceived()
				organicTTIMilestoneManager.L2.dataProcessingStarted()
				setFetchedMarketplaceCompleted()
				widgetsPercievedTTIManager.L2.dataProcessingCompleted()
				organicTTIMilestoneManager.L2.dataProcessingCompleted()
			end
		end

		React.useEffect(fn2, {
			state,
			state7,
			if fFlagAXMigrateAllTabToSduiDev then setFetchedMarketplaceCompleted else nil
		})
	end

	local v42 = {
		fetchMarketplace = v41,
		hasFetched = v11,
		isFetching = v10,
		fetchedMarketplaceTimestamp = nil
	}

	if not fFlagAXPrefetchOnlyWithinTTL then
		v12 = nil
	end

	v42.fetchedMarketplaceTimestamp = v12
	return v42
end

return useMarketplaceResultsFetcher
