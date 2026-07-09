local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local NamedRefConstants = require(Modules.AvatarExperience.Common.NamedRefConstants)
local withStyle = UIBlox.Style.withStyle

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceExperiments = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local FFlagAXLegacyIXPExposureLogging = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXLegacyIXPExposureLogging
local ResultsList = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsList)
local RemoveSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.RemoveSearchInCatalog)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local withContextValue = require(Modules.AvatarExperience.Common.withContextValue)
local PageObjectManagerContext = require(Modules.AvatarExperience.Common.Context.PageObjectManagerContext)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local ClearSelectedTopics = require(Modules.AvatarExperience.Catalog.Actions.ClearSelectedTopics)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local FetchCatalogSearchWithSponsoredItems = require(Modules.AvatarExperience.Catalog.Thunks.FetchCatalogSearchWithSponsoredItems)
local FetchWidgetInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchWidgetInfo)
local withNamedRefs = require(Modules.AvatarExperience.Common.Context.withNamedRefs)
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local ResetSortAndFiltersThunk = require(Modules.AvatarExperience.Catalog.Thunks.ResetSortAndFiltersThunk)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local FFlagAXRemoveDupSearchCall = require(Modules.AvatarExperience.Flags.FFlagAXRemoveDupSearchCall)
local FFlagAXResetAnalyticsMetadataOnFilterReset = require(Modules.AvatarExperience.Flags.FFlagAXResetAnalyticsMetadataOnFilterReset)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local v51 = Roact.PureComponent:extend("NavigationItemsView")
local FFlagAXEnableCatalogCreatorHttpLink = require(Modules.LuaApp.Flags.FFlagAXEnableCatalogCreatorHttpLink)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local AXPrefetchMarketplaceIXP = AvatarExperienceExperiments.AXPrefetchMarketplaceIXP
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local useMarketplaceResultsFetcher = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useMarketplaceResultsFetcher)
local useMarketplaceResultsFetcherSdui = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useMarketplaceResultsFetcherSdui)
local useDispatchPendingCatalogDeepLink = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useDispatchPendingCatalogDeepLink)
local useResultsAreSduiEnabled = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useResultsAreSduiEnabled)
local useSduiWidgetTTIPrimaryDataReady = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useSduiWidgetTTIPrimaryDataReady)
local useSduiWidgetTTITileLatency = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useSduiWidgetTTITileLatency)
local SduiWidgetTTITileLatencyContext = require(CorePackages.Workspace.Packages.AvatarExperienceServerDrivenUi).Context.SduiWidgetTTITileLatencyContext
local useGetSelectedCategoryAndSubcategoryId = require(Modules.AvatarExperience.Catalog.Hooks.useGetSelectedCategoryAndSubcategoryId)
local FFlagAXUnifiedMarketplaceResultsFetcher = AvatarExperienceFlags.FFlagAXUnifiedMarketplaceResultsFetcher
local FFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local FIntAXPrefetchTTL = AvatarExperienceFlags.FIntAXPrefetchTTL
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local AXCatalogRealTimeRecommendationsIXP = AvatarExperienceExperiments.AXCatalogRealTimeRecommendationsIXP
local v69 = game:DefineFastInt("AXCatalogExitReEnterRefreshInterval", 60)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXSduiWidgetsTTITracking = AvatarExperienceFlags.FFlagAXSduiWidgetsTTITracking
local UserIsInExperiment = AvatarExperienceFlags.FFlagsAXPrefetchMarketplaceThumbnailsXP.UserIsInExperiment
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local OrganicTTIMilestoneManager = AvatarExperienceTTIPerformance.OrganicTTIMilestoneManager
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local selectFilterCount = require(Modules.AvatarExperience.Catalog.Selectors.selectFilterCount)
local getShouldPageUseWidgetOnlyFetcher = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Utils.getShouldPageUseWidgetOnlyFetcher
local t1 = {
	[AvatarScreen.AvatarEditor] = true,
	[AvatarScreen.ProfilePictureEditorEmotes] = true,
	[AvatarScreen.MySharedAvatars] = true,
	[AvatarScreen.SearchLandingFocusedWidgetPage] = not not AXRecentlyViewedSearchItemsIXPTest.isEnabled() or nil
}

v51.validateProps = t.strictInterface({
	defaultChildRef = t.optional(t.table),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	NextSelectionUp = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	multiTryOnBottomBarRef = t.optional(t.table),
	itemDetailsPeekViewRefs = t.table,
	categoryId = t.string,
	subcategoryId = t.optional(t.string),
	minPrice = t.number,
	maxPrice = t.number,
	selectedTopics = t.optional(t.table),
	catalogSort = t.string,
	catalogSortAggregation = t.string,
	searchParameters = t.optional(t.table),
	searchTime = t.optional(t.number),
	searchUuid = t.string,
	categoryInfo = t.table,
	creatorFilter = t.string,
	salesTypeFilter = t.string,
	unavailableItemFilter = t.string,
	wearTimeFilter = t.optional(t.string),
	widgetFetchTime = t.optional(t.number),
	externalNavigationRequest = if not FFlagAXEnableCatalogCreatorHttpLink then nil else t.table,
	isRecentMarketplaceUser = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else t.optional(t.boolean),
	screenSize = if not FFlagAXPassScreenSizeToWidgetApi then nil else t.string,
	filterCount = if not FFlagAXPassScreenSizeToWidgetApi then nil else t.number,
	setSearchType = t.callback,
	setSearchParameters = t.callback,
	dispatchSearch = t.callback,
	fetchWidgetInfo = t.callback,
	dispatchRemoveSearch = t.callback,
	clearSelectedTopics = t.callback,
	resetSortAndFilters = t.callback,
	dispatchCatalogTilesLatencyStartTracker = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else t.callback,
	pageObjectManager = t.optional(t.table),
	avatarRoute = AvatarRoute.Interface,
	namedRefs = t.table,
	networking = t.callback,
	catalogAnalytics = t.table,
	hasPrefetchedMarketplace = if not AXPrefetchMarketplaceIXP.isEnabled() and not FFlagAXUnifiedMarketplaceResultsFetcher then nil else t.optional(t.boolean),
	isPrefetchingMarketplace = if not AXPrefetchMarketplaceIXP.isEnabled() and not FFlagAXUnifiedMarketplaceResultsFetcher then nil else t.optional(t.boolean),
	fetchMarketplace = if not AXPrefetchMarketplaceIXP.isEnabled() and not FFlagAXUnifiedMarketplaceResultsFetcher then nil else t.optional(t.callback),
	fetchedMarketplaceTimestamp = if not FFlagAXPrefetchOnlyWithinTTL then nil else t.optional(t.number),
	resultsAreSduiEnabled = if not FFlagAXMigrateAllTabToSduiDev then nil else t.optional(t.boolean)
})

local function isCatalogPage(p1) -- line: 190
	-- upvalues: AvatarScreen (copy)
	return p1.avatarRoute.opaque.name == AvatarScreen.Catalog
end
local function isCatalogSearchPage(p2) -- line: 194
	-- upvalues: AvatarScreen (copy)
	return p2.avatarRoute.opaque.name == AvatarScreen.CatalogSearch
end

local v87 = if not AXCatalogRealTimeRecommendationsIXP.isEnabled() then nil else function(p3) -- line: 199
	-- upvalues: AvatarScreen (copy), Constants2 (copy)
	if p3.avatarRoute.opaque.name ~= AvatarScreen.Catalog then
		return false
	end

	local categoryInfo = p3.categoryInfo

	if not categoryInfo then
		return false
	end

	return categoryInfo.Id == Constants2.DefaultCatalogCategoryId
end

function v51.init(p4) -- line: 216
	-- upvalues: AvatarScreen (copy), NamedRefConstants (copy), Roact (copy), Signal (copy), AXPrefetchMarketplaceIXP (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXMigrateAllTabToSduiDev (copy), RobloxAppEnums (copy), CatalogUtils (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXUnifiedMarketplaceResultsFetcher (copy)
	p4.itemsListRef = p4.props.namedRefs[AvatarScreen.Catalog .. NamedRefConstants.ItemsList]
	p4.scrollingFrameRef = Roact.createRef()
	p4.navBarRef = Roact.createRef()
	p4.backToTopSignal = Signal.new()
	p4:setState({
		restorePreviousChildFocus = true,
		isInitialPrefetch = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else p4.props.isInitialPrefetch,
		hasEnteredAvatarExperience = not AXCatalogRealTimeRecommendationsIXP.isEnabled() and nil
	})

	if AXCatalogRealTimeRecommendationsIXP.isEnabled() or FFlagAXMigrateAllTabToSduiDev then
		p4.lastMarketplaceFetchTime = 0
	end

	function p4.dispatchInitialSearch() -- line: 236
		-- upvalues: p4 (copy), RobloxAppEnums (copy)
		local dispatchSearch = p4.props.dispatchSearch
		local setSearchParameters = p4.props.setSearchParameters
		local categoryInfo = p4.props.categoryInfo
		local searchUuid = p4.props.searchUuid

		p4.props.setSearchType(searchUuid, RobloxAppEnums.SearchTypes.Catalog)
		setSearchParameters(searchUuid, categoryInfo, p4.props.catalogSort, p4.props.catalogSortAggregation, p4.props.minPrice, p4.props.maxPrice, p4.props.selectedTopics)

		return dispatchSearch(p4.props.networking, searchUuid, categoryInfo)
	end
	function p4.fetchWidgetInfo(p5, p6) -- line: 256
		-- upvalues: CatalogUtils (copy), p4 (copy)
		local v183 = nil

		if p5 then
			v183 = CatalogUtils.getContextForWidgetsById(p4.props.avatarRoute.opaque.name, p5, p6)
		end

		return p4.props.fetchWidgetInfo(p4.props.networking, nil, v183)
	end

	if FFlagAXCatalogCategoriesSDUI then
		function p4.initialSearch() -- line: 270
			-- upvalues: FFlagAXUnifiedMarketplaceResultsFetcher (copy), p4 (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXMigrateAllTabToSduiDev (copy)
			if FFlagAXUnifiedMarketplaceResultsFetcher then
				p4.props.fetchMarketplace()

				if AXCatalogRealTimeRecommendationsIXP.isEnabled() or FFlagAXMigrateAllTabToSduiDev then
					p4.lastMarketplaceFetchTime = os.time()

					return
				end
			else
				p4.dispatchInitialSearch()
			end
		end
		function p4.retrySearch() -- line: 290
			-- upvalues: FFlagAXUnifiedMarketplaceResultsFetcher (copy), p4 (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXMigrateAllTabToSduiDev (copy)
			if FFlagAXUnifiedMarketplaceResultsFetcher then
				p4.props.fetchMarketplace(if not p4.props.resultsAreSduiEnabled then nil else {
					forceRefresh = true
				})

				if AXCatalogRealTimeRecommendationsIXP.isEnabled() or FFlagAXMigrateAllTabToSduiDev then
					p4.lastMarketplaceFetchTime = os.time()

					return
				end
			else
				p4.dispatchInitialSearch()
			end
		end
	end
end

if AXPrefetchMarketplaceIXP.isEnabled() then
	function v51.hasPrefetchedMarketplace(p7) -- line: 305
		-- upvalues: IxpUtils (copy), AXPrefetchMarketplaceIXP (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAXPrefetchOnlyWithinTTL (copy), FIntAXPrefetchTTL (copy), FFlagAXLegacyIXPExposureLogging (copy), UserIsInExperiment (copy), IXPServiceWrapper (copy), AppUserLayers (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXMigrateAllTabToSduiDev (copy)
		local v99 = IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)
		local v100 = IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.UserIsInExperiment)

		if not p7.props.isRecentMarketplaceUser then
			return false
		end

		sendAXCounterV2(Constants.Counter.PrefetchMarketplace.enteredMarketplaceAndIsRecentUser)

		if v100 then
			local v101 = not FFlagAXPrefetchOnlyWithinTTL or (not p7.props.fetchedMarketplaceTimestamp or os.time() - p7.props.fetchedMarketplaceTimestamp <= FIntAXPrefetchTTL)

			if not v101 then
				return false
			end

			sendAXCounterV2(Constants.Counter.PrefetchMarketplace.inExperimentAndIsRecentUserAndEnteredMarketplace)

			if FFlagAXLegacyIXPExposureLogging then
				if AXPrefetchMarketplaceIXP.logExposureEnabled and AXPrefetchMarketplaceIXP.logExposureEnabled() then
					IxpUtils.logExperimentExposure(AXPrefetchMarketplaceIXP)
				end

				if UserIsInExperiment then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.AvatarExperienceUAPerformance)
					sendAXCounterV2(Constants.Counter.PrefetchMarketplace.inExperimentAndIsRecentUserAndEnteredMarketplaceThumbnails)
				end
			else
				IxpUtils.logExperimentExposure(AXPrefetchMarketplaceIXP)
			end

			if v99 and v101 then
				if GetFFlagEnableCatalogTileLoadingLatency() then
					TTIPerformanceManager.Surface.Marketplace.Root.startTracking()
					p7.props.dispatchCatalogTilesLatencyStartTracker(p7.props.searchUuid)
				end

				if AXCatalogRealTimeRecommendationsIXP.isEnabled() or FFlagAXMigrateAllTabToSduiDev then
					p7.lastMarketplaceFetchTime = os.time()
				end

				p7:setState({
					isInitialPrefetch = true
				})

				return true
			end
		end

		return false
	end
end

function v51.didMount(p8) -- line: 382
	-- upvalues: AXPrefetchMarketplaceIXP (copy), FFlagAXUnifiedMarketplaceResultsFetcher (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXMigrateAllTabToSduiDev (copy)
	if AXPrefetchMarketplaceIXP.isEnabled() and p8:hasPrefetchedMarketplace() then
		return
	end

	if FFlagAXUnifiedMarketplaceResultsFetcher then
		p8.props.fetchMarketplace()

		if AXCatalogRealTimeRecommendationsIXP.isEnabled() or FFlagAXMigrateAllTabToSduiDev then
			p8.lastMarketplaceFetchTime = os.time()

			return
		end
	else
		p8.dispatchInitialSearch()
		p8.fetchWidgetInfo(p8.props.categoryId, p8.props.subcategoryId)
	end
end
function v51.searchResultsAreOld(p9, _, p11, p12) -- line: 407
	local v107 = if not p12 then p9.props.searchTime else p12.searchTime

	if not p11.TimeToRefresh or (not (p11.TimeToRefresh >= 0) or not v107) then
		return false
	end

	return tick() - v107 > p11.TimeToRefresh
end
function v51.updateSearchParams(p13, p14) -- line: 417
	-- upvalues: GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), FFlagAXSduiWidgetsTTITracking (copy), OrganicTTIMilestoneManager (copy), FFlagAXPassScreenSizeToWidgetApi (copy), getShouldPageUseWidgetOnlyFetcher (copy), Constants (copy)
	local categoryInfo = p14.categoryInfo
	local searchUuid = p14.searchUuid
	local dispatchSearch = p13.props.dispatchSearch
	local setSearchParameters = p13.props.setSearchParameters
	local fetchWidgetInfo = p13.fetchWidgetInfo
	local v115 = p14.categoryId ~= p13.props.categoryId or p14.subcategoryId ~= p13.props.subcategoryId
	local v116 = p14.wearTimeFilter ~= p13.props.wearTimeFilter

	if v115 or (p14.catalogSort ~= p13.props.catalogSort or p14.catalogSortAggregation ~= p13.props.catalogSortAggregation or p14.minPrice ~= p13.props.minPrice or p14.maxPrice ~= p13.props.maxPrice or p14.selectedTopics ~= p13.props.selectedTopics or p14.creatorFilter ~= p13.props.creatorFilter or p14.salesTypeFilter ~= p13.props.salesTypeFilter or p14.unavailableItemFilter ~= p13.props.unavailableItemFilter or v116) then
		if v115 then
			p13.props.clearSelectedTopics()

			local v117 = p13.props.searchParameters[searchUuid]

			if v117 == nil then
				setSearchParameters(searchUuid, categoryInfo, p14.catalogSort, p14.catalogSortAggregation, p14.minPrice, p14.maxPrice, p14.selectedTopics, p14.creatorFilter, p14.salesTypeFilter, p14.unavailableItemFilter, p14.wearTimeFilter)

				if GetFFlagEnableCatalogTileLoadingLatency() then
					TTIPerformanceManager.Surface.Marketplace.Root.startTracking()

					if not p13.props.resultsAreSduiEnabled or not FFlagAXSduiWidgetsTTITracking then
						OrganicTTIMilestoneManager.L2.primaryDataStarted()
						OrganicTTIMilestoneManager.L3.networkFetch()
					end

					p13.props.dispatchCatalogTilesLatencyStartTracker(searchUuid)
				end

				dispatchSearch(p13.props.networking, searchUuid, categoryInfo)
				fetchWidgetInfo(p14.categoryId, p14.subcategoryId)
			else
				local v118 = p13:searchResultsAreOld(searchUuid, categoryInfo, p14) or (v117.catalogSort and v117.catalogSort ~= p14.catalogSort or (v117.catalogSortAggregation and v117.catalogSortAggregation ~= p14.catalogSortAggregation or (v117.minPrice and v117.minPrice ~= p14.minPrice or (v117.maxPrice and v117.maxPrice ~= p14.maxPrice or (v117.selectedTopics and v117.selectedTopics ~= p14.selectedTopics or (v117.creatorFilter and v117.creatorFilter ~= p14.creatorFilter or (v117.salesTypeFilter and v117.salesTypeFilter ~= p14.salesTypeFilter or v117.unavailableItemFilter and v117.unavailableItemFilter ~= p14.unavailableItemFilter)))))))
				local v119 = if not FFlagAXPassScreenSizeToWidgetApi then nil else getShouldPageUseWidgetOnlyFetcher(p14.categoryInfo, p14.filterCount, v117 and v117.searchKeyword)

				if FFlagAXPassScreenSizeToWidgetApi and v119 then
					v118 = false
				end

				if v118 then
					if p13:searchResultsAreOld(searchUuid, categoryInfo, p14) then
						p13.props.catalogAnalytics.sendAXCounter(Constants.Counter.CatalogRefresh.StaleResults)
					end

					p13.props.pageObjectManager:storePageObject(searchUuid, nil)
					p13.props.dispatchRemoveSearch(searchUuid)

					if GetFFlagEnableCatalogTileLoadingLatency() then
						TTIPerformanceManager.Surface.Marketplace.Root.startTracking()

						if not p13.props.resultsAreSduiEnabled or not FFlagAXSduiWidgetsTTITracking then
							OrganicTTIMilestoneManager.L2.primaryDataStarted()
							OrganicTTIMilestoneManager.L3.networkFetch()
						end

						p13.props.dispatchCatalogTilesLatencyStartTracker(searchUuid)
					end

					setSearchParameters(searchUuid, categoryInfo, p14.catalogSort, p14.catalogSortAggregation, p14.minPrice, p14.maxPrice, p14.selectedTopics, p14.creatorFilter, p14.salesTypeFilter, p14.unavailableItemFilter, p14.wearTimeFilter)
					dispatchSearch(p13.props.networking, searchUuid, categoryInfo)
					fetchWidgetInfo(p14.categoryId, p14.subcategoryId)
				end
			end
		else
			p13.props.pageObjectManager:storePageObject(searchUuid, nil)
			p13.props.dispatchRemoveSearch(searchUuid)
			setSearchParameters(searchUuid, categoryInfo, p14.catalogSort, p14.catalogSortAggregation, p14.minPrice, p14.maxPrice, p14.selectedTopics, p14.creatorFilter, p14.salesTypeFilter, p14.unavailableItemFilter, p14.wearTimeFilter)
			dispatchSearch(p13.props.networking, searchUuid, categoryInfo)
		end

		if p13.scrollingFrameRef.current then
			p13.scrollingFrameRef.current.CanvasPosition = Vector2.new()
		end
	end
end
function v51.willUpdate(p15, p16) -- line: 586
	-- upvalues: AvatarScreen (copy), FFlagAXRemoveDupSearchCall (copy)
	if p15.props.avatarRoute.opaque.name == AvatarScreen.Catalog and p16.avatarRoute.opaque.name ~= AvatarScreen.Catalog then
		p15.props.clearSelectedTopics()
		p15.props.resetSortAndFilters()
	end

	if p15.props.avatarRoute.opaque.name ~= AvatarScreen.Catalog and p16.avatarRoute.opaque.name == AvatarScreen.Catalog then
		p15.props.clearSelectedTopics()
	end

	if FFlagAXRemoveDupSearchCall and p16.avatarRoute.opaque.name ~= AvatarScreen.Catalog then
		return
	end

	p15:updateSearchParams(p16)
end
function v51.renderWithStyle(p17, p18) -- line: 610
	-- upvalues: Roact (copy), Focusable (copy), ResultsList (copy), FFlagLuaAppsDefaultSelection (copy), CatalogConstants (copy), FFlagAXMigrateAllTabToSduiDev (copy), FFlagAXCatalogCategoriesSDUI (copy)
	local Theme = p18.Theme
	local defaultChildRef = p17.props.defaultChildRef
	local NextSelectionUp = p17.props.NextSelectionUp

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = Theme.BackgroundDefault.Transparency or 1,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Ref] = defaultChildRef,
		restorePreviousChildFocus = p17.state.restorePreviousChildFocus,
		defaultChild = p17.navBarRef,
		NextSelectionRight = p17.props.NextSelectionRight
	}, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		ResultsList = Roact.createElement(ResultsList, {
			fromSearch = false,
			layoutOrder = 2,
			frameRef = p17.itemsListRef,
			defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p17.props.defaultFocusRef,
			navBarRef = p17.navBarRef,
			analyticsContext = CatalogConstants.AnalyticsContext.Catalog,
			searchUuid = p17.props.searchUuid,
			scrollingFrameRef = p17.scrollingFrameRef,
			onRetry = if not FFlagAXMigrateAllTabToSduiDev then if not FFlagAXCatalogCategoriesSDUI then p17.dispatchInitialSearch else p17.initialSearch else p17.retrySearch,
			NextSelectionUp = NextSelectionUp,
			backToTopSignal = p17.backToTopSignal,
			multiTryOnBottomBarRef = p17.props.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = p17.props.itemDetailsPeekViewRefs
		})
	})
end
function v51.render(p19) -- line: 654
	-- upvalues: withStyle (copy)
	return withStyle(function(p20) -- line: 655
		-- upvalues: p19 (copy)
		return p19:renderWithStyle(p20)
	end)
end

if AXCatalogRealTimeRecommendationsIXP.isEnabled() then
	function v51.handleExitAndReEnterAvatarExperience(p21, p22) -- line: 661
		-- upvalues: v87 (copy), FFlagAXUnifiedMarketplaceResultsFetcher (copy), v69 (copy), IxpUtils (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXLegacyIXPExposureLogging (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAXMigrateAllTabToSduiDev (copy)
		local isVisible = p21.props.avatarRoute.isVisible
		local isVisible2 = p22.avatarRoute.isVisible

		if isVisible and not p21.state.hasEnteredAvatarExperience then
			p21:setState({
				hasEnteredAvatarExperience = true
			})
		end

		if isVisible and (not isVisible2 and p21.state.hasEnteredAvatarExperience) and v87(p21.props) and FFlagAXUnifiedMarketplaceResultsFetcher and p21.props.fetchMarketplace then
			local timestamp = os.time()

			if timestamp - p21.lastMarketplaceFetchTime >= v69 then
				if IxpUtils.readTestVariable(AXCatalogRealTimeRecommendationsIXP.UserIsInExperiment) then
					if FFlagAXLegacyIXPExposureLogging then
						if AXCatalogRealTimeRecommendationsIXP.logExposureEnabled and AXCatalogRealTimeRecommendationsIXP.logExposureEnabled() then
							IxpUtils.logExperimentExposure(AXCatalogRealTimeRecommendationsIXP)
						end
					else
						IxpUtils.logExperimentExposure(AXCatalogRealTimeRecommendationsIXP)
					end
				end

				sendAXCounterV2(Constants.Counter.FetchMarketplace.ExitAndReEnterRefreshCounter)

				if IxpUtils.readTestVariable(AXCatalogRealTimeRecommendationsIXP.EnabledForUser) then
					sendAXCounterV2(Constants.Counter.FetchMarketplace.ExitAndReEnterRefreshTreatment)
					p21.props.fetchMarketplace(if not FFlagAXMigrateAllTabToSduiDev or not p21.props.resultsAreSduiEnabled then nil else {
						forceRefresh = true
					})
					p21.lastMarketplaceFetchTime = timestamp

					return
				end
			end
		end
	end
end

function v51.didUpdate(p23, p24) -- line: 724
	-- upvalues: AvatarScreen (copy), t1 (copy), AXCatalogRealTimeRecommendationsIXP (copy), FFlagAXPassScreenSizeToWidgetApi (copy), getShouldPageUseWidgetOnlyFetcher (copy), FFlagAXEnableCatalogCreatorHttpLink (copy), DeepLinkUtils (copy), FFlagAXMigrateAllTabToSduiDev (copy), v69 (copy), AXPrefetchMarketplaceIXP (copy), IxpUtils (copy), sendAXCounterV2 (copy), Constants (copy)
	local name = p23.props.avatarRoute.current.name
	local name2 = p24.avatarRoute.current.name

	if name == AvatarScreen.Catalog then
		if not p23.state.restorePreviousChildFocus then
			p23:setState({
				restorePreviousChildFocus = true
			})
		end
	elseif t1[name] and name2 == AvatarScreen.Catalog and p23.state.restorePreviousChildFocus then
		p23:setState({
			restorePreviousChildFocus = false
		})
	end

	if AXCatalogRealTimeRecommendationsIXP.isEnabled() then
		p23:handleExitAndReEnterAvatarExperience(p24)
	end

	local v137 = if not FFlagAXPassScreenSizeToWidgetApi or not p23.props.searchParameters then nil else p23.props.searchParameters[p23.props.searchUuid]
	local v138 = if not FFlagAXPassScreenSizeToWidgetApi then nil else getShouldPageUseWidgetOnlyFetcher(p23.props.categoryInfo, p23.props.filterCount, v137 and v137.searchKeyword)

	if FFlagAXPassScreenSizeToWidgetApi and p23.props.screenSize and p24.screenSize and p23.props.screenSize ~= p24.screenSize and v138 then
		p23.props.fetchMarketplace()
	end

	if p24.avatarRoute.opaque.name == AvatarScreen.CatalogSearch and p23.props.avatarRoute.opaque.name == AvatarScreen.Catalog then
		if FFlagAXEnableCatalogCreatorHttpLink then
			if p23.props.externalNavigationRequest == p24.externalNavigationRequest and not DeepLinkUtils.catalogDeepLinkExists(p23.props.externalNavigationRequest) then
				p23.props.resetSortAndFilters()
			end
		else
			p23.props.resetSortAndFilters()
		end
	end

	if FFlagAXMigrateAllTabToSduiDev and p23.props.resultsAreSduiEnabled and p23.props.fetchMarketplace then
		local v139 = p23.props.avatarRoute.isVisible and p24.avatarRoute.isVisible
		local resultsAreSduiEnabled = p24.resultsAreSduiEnabled
		local v141 = p23.props.avatarRoute.opaque.name == AvatarScreen.Catalog and p24.avatarRoute.opaque.name ~= AvatarScreen.Catalog

		if v139 and (not resultsAreSduiEnabled or v141) then
			local timestamp = os.time()

			if timestamp - (p23.lastMarketplaceFetchTime or 0) >= v69 then
				p23.props.fetchMarketplace({
					forceRefresh = true
				})
				p23.lastMarketplaceFetchTime = timestamp
			end
		end
	end

	local v143 = p23.props.categoryInfo and p23.props.categoryInfo.ShowWidgets
	local v144 = p24.categoryInfo and p24.categoryInfo.ShowWidgets
	local v145 = v143 and not v144
	local v146 = name == AvatarScreen.Catalog and name2 == AvatarScreen.AvatarExperienceLandingPage

	if v145 or v146 then
		if FFlagAXPassScreenSizeToWidgetApi and v138 then
			p23.props.fetchMarketplace()
		else
			p23.fetchWidgetInfo(p23.props.categoryId, p23.props.subcategoryId)
		end
	end

	local v147 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)
	local v148 = if not v147 then nil else p24.isPrefetchingMarketplace and not p24.hasPrefetchedMarketplace
	local v149 = if not v147 then nil else not p23.props.isPrefetchingMarketplace and not p23.props.hasPrefetchedMarketplace

	if v147 then
		if p23.props.hasPrefetchedMarketplace and p23.state.isInitialPrefetch then
			sendAXCounterV2(Constants.Counter.PrefetchMarketplace.inTreatmentAndHasPrefetchedMarketplace)
			p23:setState({
				isInitialPrefetch = false
			})
		end

		if v148 and v149 and p23.state.isInitialPrefetch then
			sendAXCounterV2(Constants.Counter.PrefetchMarketplace.enteredMarketplaceButPrefetchFailed)
			p23.dispatchInitialSearch()
			p23.fetchWidgetInfo(p23.props.categoryId, p23.props.subcategoryId)
			p23:setState({
				isInitialPrefetch = false
			})
		end
	end
end

local function mapStateToProps(p25, p26) -- line: 870
	-- upvalues: FFlagAXEditorSubcategoryFilters (copy), Utils (copy), AXPrefetchMarketplaceIXP (copy), FFlagAXEnableCatalogCreatorHttpLink (copy), FFlagAXPassScreenSizeToWidgetApi (copy), selectFilterCount (copy)
	local categoryId = p26.categoryId
	local subcategoryId = p26.subcategoryId
	local categoryInfo = p26.categoryInfo
	local subButton = p25.AvatarExperience.AvatarEditor.Categories.subButton
	local v156 = if not FFlagAXEditorSubcategoryFilters then nil else p25.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
	local v157, _ = Utils.getSearchUuidAndAssetTypes(categoryInfo, subButton, if not FFlagAXEditorSubcategoryFilters then nil else v156)
	local v159 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else p25.AvatarExperience.Catalog.Metadata.isRecentMarketplaceUser

	return {
		categoryInfo = categoryInfo,
		categoryId = categoryId,
		subcategoryId = subcategoryId,
		minPrice = p25.AvatarExperience.Catalog.SortAndFilters.PriceRange.minPrice,
		maxPrice = p25.AvatarExperience.Catalog.SortAndFilters.PriceRange.maxPrice,
		selectedTopics = if categoryInfo == nil or not categoryInfo.ShowTopics then nil else p25.AvatarExperience.Catalog.SortAndFilters.SelectedTopics,
		catalogSort = p25.AvatarExperience.Catalog.SortAndFilters.CatalogSort,
		catalogSortAggregation = p25.AvatarExperience.Catalog.SortAndFilters.CatalogSortAggregation,
		creatorFilter = p25.AvatarExperience.Catalog.SortAndFilters.CreatorFilter,
		salesTypeFilter = p25.AvatarExperience.Catalog.SortAndFilters.SalesTypeFilter,
		unavailableItemFilter = p25.AvatarExperience.Catalog.SortAndFilters.UnavailableItemFilter,
		wearTimeFilter = p25.AvatarExperience.Catalog.SortAndFilters.WearTimeFilter,
		searchParameters = p25.SearchesParameters,
		searchTime = p25.SearchTimes and p25.SearchTimes[v157] or nil,
		searchUuid = v157,
		widgetFetchTime = p25.AvatarExperience.Common.Widgets.WidgetInfo.FetchTime,
		externalNavigationRequest = if not FFlagAXEnableCatalogCreatorHttpLink then nil else p25.AvatarExperience.ExternalNavigationRequest,
		isRecentMarketplaceUser = v159,
		filterCount = if not FFlagAXPassScreenSizeToWidgetApi then nil else selectFilterCount(p25)
	}
end
local function mapDispatchToProps(p27) -- line: 919
	-- upvalues: SetSearchType (copy), SetSearchParameters (copy), FetchCatalogSearchWithSponsoredItems (copy), FetchWidgetInfo (copy), RemoveSearchInCatalog (copy), ClearSelectedTopics (copy), FFlagAXResetAnalyticsMetadataOnFilterReset (copy), ResetSortAndFiltersThunk (copy), ResetSortAndFilters (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), CatalogTilesLatencyTracker (copy)
	return {
		setSearchType = function(p28, p29) -- line: 921
			-- upvalues: p27 (copy), SetSearchType (copy)
			return p27(SetSearchType(p28, p29))
		end,
		setSearchParameters = function(p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40) -- line: 925
			-- upvalues: p27 (copy), SetSearchParameters (copy)
			return p27(SetSearchParameters(p30, {
				categoryInfo = p31,
				catalogSort = p32,
				catalogSortAggregation = p33,
				minPrice = p34,
				maxPrice = p35,
				selectedTopics = p36,
				creatorFilter = p37,
				salesTypeFilter = p38,
				unavailableItemFilter = p39,
				wearTimeFilter = p40
			}))
		end,
		dispatchSearch = function(p41, p42, p43) -- line: 952
			-- upvalues: p27 (copy), FetchCatalogSearchWithSponsoredItems (copy)
			return p27(FetchCatalogSearchWithSponsoredItems(p41, {
				recordSearchTime = true,
				searchUuid = p42,
				categoryInfo = p43
			}))
		end,
		fetchWidgetInfo = function(p44, p45, p46) -- line: 960
			-- upvalues: p27 (copy), FetchWidgetInfo (copy)
			return p27(FetchWidgetInfo(p44, p45, p46))
		end,
		dispatchRemoveSearch = function(p47) -- line: 964
			-- upvalues: p27 (copy), RemoveSearchInCatalog (copy)
			p27(RemoveSearchInCatalog(p47))
		end,
		clearSelectedTopics = function() -- line: 968
			-- upvalues: p27 (copy), ClearSelectedTopics (copy)
			p27(ClearSelectedTopics())
		end,
		resetSortAndFilters = function() -- line: 972
			-- upvalues: FFlagAXResetAnalyticsMetadataOnFilterReset (copy), p27 (copy), ResetSortAndFiltersThunk (copy), ResetSortAndFilters (copy)
			if FFlagAXResetAnalyticsMetadataOnFilterReset then
				p27(ResetSortAndFiltersThunk())

				return
			end

			p27(ResetSortAndFilters())
		end,
		dispatchCatalogTilesLatencyStartTracker = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else function(p48) -- line: 981
			-- upvalues: p27 (copy), CatalogTilesLatencyTracker (copy)
			p27(CatalogTilesLatencyTracker.StartTracking(p48))
		end
	}
end

local v90 = withNamedRefs((withAvatarRoute((withContextValue(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v51), PageObjectManagerContext.Consumer, "pageObjectManager")))))
local u91 = RoactServices.connect({
	networking = RoactNetworking,
	catalogAnalytics = Analytics
})(v90)

local function NavigationItemsViewWrapper(p49) -- line: 998
	-- upvalues: AXPrefetchMarketplaceIXP (copy), IxpUtils (copy), FFlagAXUnifiedMarketplaceResultsFetcher (copy), useMarketplaceResultsFetcher (copy), FFlagAXPrefetchOnlyWithinTTL (copy), FFlagAXMigrateAllTabToSduiDev (copy), useDispatchPendingCatalogDeepLink (copy), useGetSelectedCategoryAndSubcategoryId (copy), useMarketplaceResultsFetcherSdui (copy), Constants2 (copy), useResultsAreSduiEnabled (copy), FFlagAXSduiWidgetsTTITracking (copy), useSduiWidgetTTIPrimaryDataReady (copy), useSduiWidgetTTITileLatency (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), FFlagAXPassScreenSizeToWidgetApi (copy), getAXMarketplaceWidgetStore (copy), SignalsReact (copy), Roact (copy), SduiWidgetTTITileLatencyContext (copy), u91 (ref)
	local v162 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)
	local v163 = if not AXPrefetchMarketplaceIXP.isEnabled() and not FFlagAXUnifiedMarketplaceResultsFetcher then nil else useMarketplaceResultsFetcher()
	local v164 = table.clone(p49)

	if (v162 or FFlagAXUnifiedMarketplaceResultsFetcher) and v163 then
		v164.hasPrefetchedMarketplace = v163.hasFetched
		v164.isPrefetchingMarketplace = v163.isFetching
		v164.fetchMarketplace = v163.fetchMarketplace
		v164.fetchedMarketplaceTimestamp = if not FFlagAXPrefetchOnlyWithinTTL then nil else v163.fetchedMarketplaceTimestamp
	end

	local v165 = nil

	if FFlagAXMigrateAllTabToSduiDev then
		useDispatchPendingCatalogDeepLink()

		local v166, _ = useGetSelectedCategoryAndSubcategoryId()
		local v168 = useMarketplaceResultsFetcherSdui({
			categoryId = v166 or Constants2.DefaultCatalogCategoryId
		})
		local v169 = useResultsAreSduiEnabled()

		if FFlagAXSduiWidgetsTTITracking then
			local searchUuid = v168.searchUuid
			local identifier = v168.identifier

			useSduiWidgetTTIPrimaryDataReady({
				searchUuid = searchUuid,
				resultsAreSduiEnabled = v169,
				identifier = identifier
			})
			v165 = useSduiWidgetTTITileLatency({
				searchUuid = searchUuid,
				resultsAreSduiEnabled = v169,
				identifier = identifier
			})
		end

		v164.resultsAreSduiEnabled = v169

		if v169 then
			v164.hasPrefetchedMarketplace = v168.hasFetched
			v164.isPrefetchingMarketplace = v168.isFetching
			v164.fetchedMarketplaceTimestamp = v168.fetchedMarketplaceTimestamp
			v164.fetchMarketplace = v168.fetchMarketplace
		end
	end

	local v172 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v173 = useSignalState(v172.selectedCategoryId)
	local v174 = useSignalState(v172.selectedSubcategoryId)
	local v175 = useSignalState(v172.selectedCategoryInfo)

	v164.categoryId = v173
	v164.subcategoryId = v174
	v164.categoryInfo = v175

	if FFlagAXPassScreenSizeToWidgetApi then
		local v176 = getAXMarketplaceWidgetStore(false)

		v164.screenSize = SignalsReact.useSignalState(v176.getDebouncedScreenSize)
	end

	if FFlagAXSduiWidgetsTTITracking then
		return Roact.createElement(SduiWidgetTTITileLatencyContext.Provider, {
			value = v165
		}, {
			NavigationItemsView = Roact.createElement(u91, v164)
		})
	end

	return Roact.createElement(u91, v164)
end

return NavigationItemsViewWrapper
