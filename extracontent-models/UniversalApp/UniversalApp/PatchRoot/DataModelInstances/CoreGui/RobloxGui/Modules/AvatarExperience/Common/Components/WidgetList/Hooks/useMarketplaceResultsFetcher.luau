local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useStore = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useStore
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Stores = require(Modules.AvatarExperience.Common.Components.WidgetList.Stores)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local PageObjectManagerContext = require(Modules.AvatarExperience.Common.Context.PageObjectManagerContext)
local useGetCategoryInfo = require(Modules.AvatarExperience.Catalog.Hooks.useGetCategoryInfo)
local useGetSelectedCategoryAndSubcategoryId = require(Modules.AvatarExperience.Catalog.Hooks.useGetSelectedCategoryAndSubcategoryId)
local useCatalogCategoriesFetcher = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useCatalogCategoriesFetcher)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AXPrefetchMarketplaceIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXPrefetchMarketplaceIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local fetchCatalogSearchWithSponsoredItems = require(script.Parent.Parent.Utils.fetchCatalogSearchWithSponsoredItems)
local MarketplaceSubscriptionRefetchUtils = require(script.Parent.Parent.Utils.MarketplaceSubscriptionRefetchUtils)
local getSearchKeywordFromSearchesParameters = MarketplaceSubscriptionRefetchUtils.getSearchKeywordFromSearchesParameters
local getShouldFetchCatalogOrganicAfterWidgets = MarketplaceSubscriptionRefetchUtils.getShouldFetchCatalogOrganicAfterWidgets
local fetchHydratedWidgets = require(script.Parent.Parent.Utils.fetchHydratedWidgets)
local FetchSponsoredItems = require(Modules.AvatarExperience.Catalog.Thunks.FetchSponsoredItems)
local ApiFetchCatalogSearch = require(Modules.AvatarExperience.Catalog.Thunks.ApiFetchCatalogSearch)
local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)
local mutedError = require(Modules.LuaApp.mutedError)
local RemoveSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.RemoveSearchInCatalog)
local ClearWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.ClearWidgetInfo)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local SetSearchTime = require(Modules.LuaApp.Actions.SetSearchTime)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)

require(Modules.AvatarExperience.Catalog.Reducers.SortAndFilters)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash
local FFlagAXUnifiedMarketplaceResultsFetcher = AvatarExperienceFlags.FFlagAXUnifiedMarketplaceResultsFetcher
local FFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local FFlagAXResetFetchMarketplaceLogic = AvatarExperienceFlags.FFlagAXResetFetchMarketplaceLogic
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXFixHydratedWidgetsParams = AvatarExperienceFlags.FFlagAXFixHydratedWidgetsParams
local FFlagAXFixDataProcessingMilestoneGating = AvatarExperienceFlags.FFlagAXFixDataProcessingMilestoneGating
local FFlagAXMarketplaceSubscriptionRefetchListener = AvatarExperienceFlags.FFlagAXMarketplaceSubscriptionRefetchListener
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local WidgetsPercievedTTIManager = AvatarExperienceTTIPerformance.WidgetsPercievedTTIManager
local OrganicTTIMilestoneManager = AvatarExperienceTTIPerformance.OrganicTTIMilestoneManager
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2

function selectSortAndFilters(p1) -- line: 151
	-- upvalues: FFlagAXFixPrefetchMarketplaceStartupCrash (copy)
	if FFlagAXFixPrefetchMarketplaceStartupCrash and (not p1.AvatarExperience or not p1.AvatarExperience.Catalog) then
		return nil
	end

	return p1.AvatarExperience.Catalog.SortAndFilters
end

local function useMarketplaceResultsFetcher(t1: {[any]: any}?) -- line: 201
	-- upvalues: AXPrefetchMarketplaceIXP (copy), IxpUtils (copy), useDispatch (copy), FFlagAXResetFetchMarketplaceLogic (copy), useSelector (copy), React (copy), PageObjectManagerContext (copy), useRoactService (copy), RoactNetworking (copy), Stores (copy), useSignalState (copy), FFlagAXPrefetchOnlyWithinTTL (copy), FFlagAXMoveAllTabToWidgetOnly (copy), FFlagAXCatalogCategoriesSDUI (copy), useGetCategoryInfo (copy), useGetSelectedCategoryAndSubcategoryId (copy), Constants (copy), FFlagAXFixHydratedWidgetsParams (copy), GetCatalogCategoriesFromStore (copy), Utils (copy), mutedError (copy), useStore (copy), FFlagAXUnifiedMarketplaceResultsFetcher (copy), useCatalogCategoriesFetcher (copy), FFlagAXFixPrefetchMarketplaceStartupCrash (copy), RemoveSearchInCatalog (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), CatalogTilesLatencyTracker (copy), SetSearchType (copy), RobloxAppEnums (copy), FFlagAXMarketplaceSubscriptionRefetchListener (copy), SetSearchParameters (copy), CatalogUtils (copy), AvatarScreen (copy), ClearWidgetInfo (copy), FetchSponsoredItems (copy), CatalogConstants (copy), Logging (copy), getSearchKeywordFromSearchesParameters (copy), ApiFetchCatalogSearch (copy), WidgetsPercievedTTIManager (copy), SetSearchTime (copy), OrganicTTIMilestoneManager (copy), FFlagAXMigrateAllTabToSduiDev (copy), sendAXCounterV2 (copy), fetchHydratedWidgets (copy), getShouldFetchCatalogOrganicAfterWidgets (copy), fetchCatalogSearchWithSponsoredItems (copy), FFlagAXFixDataProcessingMilestoneGating (copy)
	local v59 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)
	local v60 = useDispatch()
	local v61 = if not FFlagAXResetFetchMarketplaceLogic then nil else useSelector(selectSortAndFilters)
	local v62 = if not FFlagAXResetFetchMarketplaceLogic then nil else React.useContext(PageObjectManagerContext.Consumer)
	local v63 = useRoactService(RoactNetworking)
	local v64 = Stores.getFetchMarketplaceStore(false)
	local v65 = useSignalState(v64.getFetchingMarketplace)
	local v66 = useSignalState(v64.getFetchedMarketplace)
	local v67 = if not FFlagAXPrefetchOnlyWithinTTL then nil else useSignalState(v64.getFetchedMarketplaceTimestamp)
	local setFetchingMarketplaceInProgress = v64.setFetchingMarketplaceInProgress
	local setFetchedMarketplaceCompleted = v64.setFetchedMarketplaceCompleted
	local v70 = if not FFlagAXMoveAllTabToWidgetOnly and not FFlagAXCatalogCategoriesSDUI then nil else v64.setFetchingMarketplaceErrorOccured
	local v71 = if not FFlagAXCatalogCategoriesSDUI then nil else v64.setCatalogCategoriesErrorOccured
	local v72 = if not FFlagAXMoveAllTabToWidgetOnly then nil else v64.setFetchingMarketplaceProcessed
	local v73 = useGetCategoryInfo()
	local v74, v75 = useGetSelectedCategoryAndSubcategoryId()
	local v76 = v74 or Constants.DefaultCatalogCategoryId
	local u77 = if not t1 or FFlagAXFixHydratedWidgetsParams then v73 else t1.categoryInfo
	local v78 = if not t1 then v76 else t1.categoryId
	local v79 = if not t1 then v75 else t1.subcategoryId

	if FFlagAXFixHydratedWidgetsParams then
		local v80 = GetCatalogCategoriesFromStore()

		u77 = Utils.getCategoryInfoById(v80, v78, v79)

		if not u77 then
			mutedError("[useMarketplaceResultsFetcher] categoryInfo is nil for categoryId: " .. tostring(v78) .. " and subcategoryId: " .. tostring(v79))
			u77 = v73
		end
	end

	local v81 = if not t1 then u77.SearchUuid else t1.searchUuid
	local v82 = useStore()
	local v83, v84 = React.useState(false)
	local u85 = nil
	local u86 = nil
	local u87 = nil
	local u88 = nil
	local u89 = nil
	local u90 = nil
	local u91 = nil
	local u92 = nil
	local u93 = nil
	local u94 = nil

	if FFlagAXMoveAllTabToWidgetOnly then
		local v95, v96 = React.useState(false)

		u85 = v95
		u86 = v96

		local v97, v98 = React.useState(false)

		u87 = v97
		u88 = v98

		local v99, v100 = React.useState(false)

		u89 = v99
		u90 = v100

		local v101, v102 = React.useState(false)

		u91 = v101
		u92 = v102

		local v103, v104 = React.useState(false)

		u93 = v103
		u94 = v104
	end

	local v105, v106 = React.useState(false)
	local v107 = (v59 or FFlagAXUnifiedMarketplaceResultsFetcher) and (not v65 and v81 ~= nil)
	local u108 = nil

	if FFlagAXCatalogCategoriesSDUI then
		u108 = useCatalogCategoriesFetcher()
	end

	local v109 = if not FFlagAXResetFetchMarketplaceLogic then nil else React.useCallback(function() -- line: 298
		-- upvalues: FFlagAXFixPrefetchMarketplaceStartupCrash (copy), v61 (copy), FFlagAXMoveAllTabToWidgetOnly (copy), u86 (ref), u88 (ref), u90 (ref), u92 (ref), u94 (ref), v84 (copy), v106 (copy), v62 (copy), v81 (copy), v60 (copy), RemoveSearchInCatalog (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), CatalogTilesLatencyTracker (copy), SetSearchType (copy), RobloxAppEnums (copy), FFlagAXMarketplaceSubscriptionRefetchListener (copy), v82 (copy), SetSearchParameters (copy), u77 (ref), v78 (copy), v79 (copy), CatalogUtils (copy), AvatarScreen (copy), ClearWidgetInfo (copy), setFetchingMarketplaceInProgress (copy)
		if FFlagAXFixPrefetchMarketplaceStartupCrash and v61 == nil then
			return
		end

		if FFlagAXMoveAllTabToWidgetOnly then
			u86(false)
			u88(false)
			u90(false)
			u92(false)
			u94(false)
		else
			v84(false)
		end

		v106(false)

		if v62 then
			v62:storePageObject(v81, nil)
		end

		v60(RemoveSearchInCatalog(v81))

		if GetFFlagEnableCatalogTileLoadingLatency() then
			TTIPerformanceManager.Surface.Marketplace.Root.startTracking()
			v60(CatalogTilesLatencyTracker.StartTracking(v81))
		end

		v60(SetSearchType(v81, RobloxAppEnums.SearchTypes.Catalog))

		local searchKeyword = nil

		if FFlagAXMarketplaceSubscriptionRefetchListener then
			local v115 = v82:getState()
			local v116 = if not v115.SearchesParameters or not v81 then nil else v115.SearchesParameters[v81]

			if v116 then
				searchKeyword = v116.searchKeyword
			end
		end

		v60(SetSearchParameters(v81, {
			categoryInfo = u77,
			catalogSort = v61.CatalogSort,
			catalogSortAggregation = v61.CatalogSortAggregation,
			minPrice = v61.PriceRange.minPrice,
			maxPrice = v61.PriceRange.maxPrice,
			selectedTopics = v61.SelectedTopics,
			creatorFilter = v61.CreatorFilter,
			salesTypeFilter = v61.SalesTypeFilter,
			unavailableItemFilter = v61.UnavailableItemFilter,
			wearTimeFilter = v61.WearTimeFilter,
			searchKeyword = if not FFlagAXMarketplaceSubscriptionRefetchListener then nil else searchKeyword
		}))

		local v117 = nil
		local v118 = v78
		local v119 = v79

		if v118 then
			local v120 = if type(v118) ~= "string" then if type(v118) ~= "number" then nil else tostring(v118) else v118
			local v121 = if type(v119) ~= "string" then if type(v119) ~= "number" then nil else tostring(v119) else v119

			if v120 then
				v117 = CatalogUtils.getContextForWidgetsById(AvatarScreen.Catalog, v120, v121)
			end
		end

		if v117 then
			v60(ClearWidgetInfo(nil, v117))
		end

		v60(ClearWidgetInfo(nil, nil))
		setFetchingMarketplaceInProgress()
	end, {
		v62,
		v81,
		v61,
		u77,
		v78,
		v79,
		setFetchingMarketplaceInProgress,
		if not FFlagAXMarketplaceSubscriptionRefetchListener then nil else v82,
		if not FFlagAXMarketplaceSubscriptionRefetchListener then nil else v60
	})
	local v110 = if not FFlagAXMoveAllTabToWidgetOnly then nil else React.useCallback(function() -- line: 405
		-- upvalues: u77 (ref), v60 (copy), FetchSponsoredItems (copy), v63 (copy), CatalogConstants (copy), u88 (ref), u92 (ref), Logging (copy)
		if u77.ShowSponsored then
			local v122 = v60(FetchSponsoredItems(v63, CatalogConstants.SponsoredItemsCategoryRecommended, CatalogConstants.SponsoredItemsToFetch))

			if v122 and v122.andThen then
				v122:andThen(function() -- line: 416
					-- upvalues: u88 (ref), u92 (ref)
					u88(true)
					u92(true)
				end, function(p2) -- line: 419
					-- upvalues: Logging (copy), u92 (ref)
					Logging.warn("useMarketplaceResultsFetcher: Fetch sponsored items failed: " .. tostring(p2))
					u92(true)
				end)

				return
			end

			u92(true)

			return
		end

		u92(true)
	end, {
		u77,
		v63,
		v60,
		u88,
		u92
	})
	local v111 = if not FFlagAXMoveAllTabToWidgetOnly then nil else React.useCallback(function() -- line: 439
		-- upvalues: v81 (copy), u77 (ref), FFlagAXMarketplaceSubscriptionRefetchListener (copy), getSearchKeywordFromSearchesParameters (copy), v82 (copy), v60 (copy), ApiFetchCatalogSearch (copy), v63 (copy), u86 (ref), u90 (ref), WidgetsPercievedTTIManager (copy), Logging (copy)
		local t2 = {
			recordSearchTime = true,
			searchUuid = v81,
			categoryInfo = u77
		}

		if FFlagAXMarketplaceSubscriptionRefetchListener then
			local v124 = getSearchKeywordFromSearchesParameters(v82, v81)

			if v124 then
				t2.searchKeyword = v124
			end
		end

		local v125 = v60(ApiFetchCatalogSearch(t2, v63))

		if v125 and v125.andThen then
			v125:andThen(function() -- line: 453
				-- upvalues: u86 (ref), u90 (ref), WidgetsPercievedTTIManager (copy)
				u86(true)
				u90(true)
				WidgetsPercievedTTIManager.L3.requestFetchCatalogSearchOrganic()
			end, function(p3) -- line: 457
				-- upvalues: Logging (copy), u90 (ref)
				Logging.warn("useMarketplaceResultsFetcher: Fetch catalog search failed: " .. tostring(p3))
				u90(true)
			end)

			return
		end

		u90(true)
	end, {
		v81,
		u77,
		v60,
		v63,
		u86,
		u90,
		if not FFlagAXMarketplaceSubscriptionRefetchListener then nil else v82
	})
	local v112 = if not FFlagAXMoveAllTabToWidgetOnly then nil else React.useCallback(function() -- line: 476
		-- upvalues: v60 (copy), SetSearchTime (copy), v81 (copy)
		v60(SetSearchTime(v81, tick()))
	end, {
		v60,
		v81
	})
	local v113 = React.useCallback(function() -- line: 486
		-- upvalues: v107 (copy), WidgetsPercievedTTIManager (copy), OrganicTTIMilestoneManager (copy), FFlagAXResetFetchMarketplaceLogic (copy), v109 (copy), setFetchingMarketplaceInProgress (copy), FFlagAXMoveAllTabToWidgetOnly (copy), v112 (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXMigrateAllTabToSduiDev (copy), u108 (ref), sendAXCounterV2 (copy), Constants (copy), v71 (copy), fetchHydratedWidgets (copy), v60 (copy), v63 (copy), u77 (ref), v82 (copy), FFlagAXFixHydratedWidgetsParams (copy), v78 (copy), v79 (copy), v110 (copy), v106 (copy), u94 (ref), FFlagAXMarketplaceSubscriptionRefetchListener (copy), getSearchKeywordFromSearchesParameters (copy), v81 (copy), getShouldFetchCatalogOrganicAfterWidgets (copy), v111 (copy), u90 (ref), v70 (copy), fetchCatalogSearchWithSponsoredItems (copy), v84 (copy)
		if not v107 then
			return
		end

		WidgetsPercievedTTIManager.L2.primaryDataStarted()
		OrganicTTIMilestoneManager.L2.primaryDataStarted()

		if FFlagAXResetFetchMarketplaceLogic then
			v109()
		else
			setFetchingMarketplaceInProgress()
		end

		if FFlagAXMoveAllTabToWidgetOnly then
			v112()

			if FFlagAXCatalogCategoriesSDUI and not FFlagAXMigrateAllTabToSduiDev then
				u108():andThen(function() -- line: 511
				end, function(p4) -- line: 513
					-- upvalues: sendAXCounterV2 (copy), Constants (copy), v71 (copy)
					warn("fetchCatalogCategories error", p4)

					local ok, result = pcall(function() -- line: 515
						-- upvalues: p4 (copy)
						return (string.sub(tostring(p4), 1, 100))
					end)

					sendAXCounterV2(Constants.Counter.Catalog.Errors.FetchCatalogCategoriesError, {
						error = not ok and "unknown" or result
					})
					v71()
				end)
			end

			WidgetsPercievedTTIManager.L3.networkFetch()
			OrganicTTIMilestoneManager.L3.networkFetch()

			local v126 = fetchHydratedWidgets(v60, v63, u77, v82, if not FFlagAXFixHydratedWidgetsParams then nil else v78, if not FFlagAXFixHydratedWidgetsParams then nil else v79)

			v110()

			if v126 and v126.andThen then
				v126:andThen(function(p5) -- line: 541
					-- upvalues: v106 (copy), u94 (ref), FFlagAXMarketplaceSubscriptionRefetchListener (copy), getSearchKeywordFromSearchesParameters (copy), v82 (copy), v81 (copy), getShouldFetchCatalogOrganicAfterWidgets (copy), v111 (copy), u90 (ref)
					v106(true)
					u94(true)

					if FFlagAXMarketplaceSubscriptionRefetchListener then
						local v135 = p5 and (p5.configuration and (p5.configuration.customizedDataMap and p5.configuration.customizedDataMap.disableOrganicContentFetch))
						local v136 = getSearchKeywordFromSearchesParameters(v82, v81)

						if getShouldFetchCatalogOrganicAfterWidgets(v135, v136) then
							v111()

							return
						end

						u90(true)

						return
					end

					if not p5 or not p5.configuration or not p5.configuration.customizedDataMap or not p5.configuration.customizedDataMap.disableOrganicContentFetch then
						v111()

						return
					end

					u90(true)
				end, function(_) -- line: 578
					-- upvalues: u90 (ref), v70 (copy)
					u90(true)
					v70()
				end)

				return
			end
		else
			if FFlagAXCatalogCategoriesSDUI and not FFlagAXMigrateAllTabToSduiDev then
				u108():andThen(function() -- line: 588
				end, function(p7) -- line: 590
					-- upvalues: sendAXCounterV2 (copy), Constants (copy), v71 (copy)
					warn("fetchCatalogCategories error", p7)

					local ok, result = pcall(function() -- line: 592
						-- upvalues: p7 (copy)
						return (string.sub(tostring(p7), 1, 100))
					end)

					sendAXCounterV2(Constants.Counter.Catalog.Errors.FetchCatalogCategoriesError, {
						error = not ok and "unknown" or result
					})
					v71()
				end)
			end

			WidgetsPercievedTTIManager.L3.networkFetch()
			OrganicTTIMilestoneManager.L3.networkFetch()

			local v127 = if not FFlagAXMarketplaceSubscriptionRefetchListener then fetchCatalogSearchWithSponsoredItems(v60, v63, v81, u77) else fetchCatalogSearchWithSponsoredItems(v60, v63, v81, u77, getSearchKeywordFromSearchesParameters(v82, v81))
			local v128 = fetchHydratedWidgets(v60, v63, u77, v82, if not FFlagAXFixHydratedWidgetsParams then nil else v78, if not FFlagAXFixHydratedWidgetsParams then nil else v79)

			if v127 and v127.andThen then
				v127:andThen(function() -- line: 635
					-- upvalues: v84 (copy), WidgetsPercievedTTIManager (copy)
					v84(true)
					WidgetsPercievedTTIManager.L3.requestFetchCatalogSearch()
				end)
			end

			if v128 and v128.andThen then
				v128:andThen(function() -- line: 643
					-- upvalues: v106 (copy)
					v106(true)
				end)
			end
		end
	end, {
		v107,
		v81,
		setFetchingMarketplaceInProgress,
		v60,
		if not FFlagAXResetFetchMarketplaceLogic then nil else v109,
		v63,
		u77,
		if not FFlagAXFixHydratedWidgetsParams then nil else v78,
		if not FFlagAXFixHydratedWidgetsParams then nil else v79,
		v82,
		v84,
		if not FFlagAXMoveAllTabToWidgetOnly then nil else u86,
		if not FFlagAXMoveAllTabToWidgetOnly then nil else v112,
		if not FFlagAXMoveAllTabToWidgetOnly then nil else u94,
		if not FFlagAXMoveAllTabToWidgetOnly then nil else u90,
		if not FFlagAXMoveAllTabToWidgetOnly then nil else v70,
		v106
	})

	if FFlagAXMoveAllTabToWidgetOnly then
		React.useEffect(function() -- line: 671
			-- upvalues: v105 (copy), u85 (ref), u87 (ref), FFlagAXFixDataProcessingMilestoneGating (copy), WidgetsPercievedTTIManager (copy), OrganicTTIMilestoneManager (copy), setFetchedMarketplaceCompleted (copy), u93 (ref), u89 (ref), u91 (ref), v72 (copy)
			if v105 and (u85 and u87) then
				if not FFlagAXFixDataProcessingMilestoneGating then
					WidgetsPercievedTTIManager.L2.dataProcessingStarted()
					OrganicTTIMilestoneManager.L2.dataProcessingStarted()
				end

				setFetchedMarketplaceCompleted()

				if not FFlagAXFixDataProcessingMilestoneGating then
					WidgetsPercievedTTIManager.L2.dataProcessingCompleted()
					OrganicTTIMilestoneManager.L2.dataProcessingCompleted()
				end
			end

			if u93 and u89 and u91 then
				if FFlagAXFixDataProcessingMilestoneGating then
					WidgetsPercievedTTIManager.L2.dataProcessingStarted()
					OrganicTTIMilestoneManager.L2.dataProcessingStarted()
				end

				v72()

				if FFlagAXFixDataProcessingMilestoneGating then
					WidgetsPercievedTTIManager.L2.dataProcessingCompleted()
					OrganicTTIMilestoneManager.L2.dataProcessingCompleted()
				end
			end
		end, {
			v105,
			u85,
			u87,
			u93,
			u89,
			u91
		})
	else
		React.useEffect(function() -- line: 708
			-- upvalues: v83 (copy), v105 (copy), WidgetsPercievedTTIManager (copy), OrganicTTIMilestoneManager (copy), setFetchedMarketplaceCompleted (copy)
			if v83 and v105 then
				WidgetsPercievedTTIManager.L3.responseReceived()
				WidgetsPercievedTTIManager.L2.dataProcessingStarted()
				OrganicTTIMilestoneManager.L3.responseReceived()
				OrganicTTIMilestoneManager.L2.dataProcessingStarted()
				setFetchedMarketplaceCompleted()
				WidgetsPercievedTTIManager.L2.dataProcessingCompleted()
				OrganicTTIMilestoneManager.L2.dataProcessingCompleted()
			end
		end, {
			v83,
			v105
		})
	end

	return {
		fetchMarketplace = v113,
		hasFetched = v66,
		isFetching = v65,
		fetchedMarketplaceTimestamp = if not FFlagAXPrefetchOnlyWithinTTL then nil else v67
	}
end

return useMarketplaceResultsFetcher
