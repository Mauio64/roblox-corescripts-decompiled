local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local CollectionService = game:GetService("CollectionService")
local IXPService = game:GetService("IXPService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local EmptyState = UIBlox.App.Indicator.EmptyState
local withStyle = UIBlox.Style.withStyle
local Promise = require(CorePackages.Packages.Promise)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local t = require(CorePackages.Packages.t)
local FitTextLabel = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitTextLabel
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Cryo = require(CorePackages.Packages.Cryo)
local mutedError = require(Modules.LuaApp.mutedError)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)

require(Modules.AvatarExperience.Catalog.Reducers.SearchCategories)

local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useStore = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useStore
local tutils = require(CorePackages.Packages.tutils)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants2 = require(Modules.LuaApp.Constants)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ApiFetchCatalogSearch = require(Modules.AvatarExperience.Catalog.Thunks.ApiFetchCatalogSearch)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local FetchDataWithErrorToasts = require(Modules.LuaApp.Thunks.FetchDataWithErrorToasts)
local SignalConnection = require(Modules.LuaApp.Components.SignalConnection)
local withNamedRefs = require(Modules.AvatarExperience.Common.Context.withNamedRefs)
local WidgetList = require(Modules.AvatarExperience.Common.Components.WidgetList)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local selectFilterCount = require(Modules.AvatarExperience.Catalog.Selectors.selectFilterCount)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local CatalogSduiFeedEntryPoint = AvatarExperienceCatalog.Components.CatalogSduiFeedEntryPoint
local useApplySduiFocusedSort = AvatarExperienceCatalog.Sdui.useApplySduiFocusedSort
local useClearSduiFocusedSort = AvatarExperienceCatalog.Sdui.useClearSduiFocusedSort
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

require(Modules.AvatarExperience.Catalog.Reducers.SortAndFilters)

local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local ResultsListTopPanel = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsListTopPanel)
local ResultsListCatalogOffersBanner = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsListCatalogOffersBanner)
local CatalogResultListNavigationContainer = require(Modules.AvatarExperience.Catalog.Components.Search.CatalogResultListNavigation.CatalogResultListNavigationContainer)
local FFlagAXMigrateCatalogResultListNavigationToMVVM = AvatarExperienceFlags.FFlagAXMigrateCatalogResultListNavigationToMVVM
local ResultsListListHeader = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsListListHeader)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Stores = require(Modules.AvatarExperience.Common.Components.WidgetList.Stores)
local AvatarExperienceScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).AvatarExperienceScreenSizeImpressionsDetector
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local useUnifiedEventImpressionsReporter = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventImpressionsReporter
local sendUnifiedEventLog = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventLog
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local useAnimatedVisibility = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.useAnimatedVisibility
local getShouldPageUseWidgetOnlyFetcher = AvatarExperienceCatalog.Utils.getShouldPageUseWidgetOnlyFetcher
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local CartIdService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Lib.CartIdService
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local SetResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.SetResultsListFocusedWidget)
local ClearResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.ClearResultsListFocusedWidget)
local SetWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.SetWidgetInfo)
local ClearWidgetInfo = require(Modules.AvatarExperience.Catalog.Actions.ClearWidgetInfo)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local EquippedDeepLinkCatalogItem = require(Modules.AvatarExperience.Catalog.Actions.EquippedDeepLinkCatalogItem)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local v94 = game:DefineFastFlag("AXFixResultListCrash", false)
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXMigrateMainNavigationInputBindings = AvatarExperienceFlags.FFlagAXMigrateMainNavigationInputBindings
local FFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local useResultsListFocusNavigationBindings = require(script.Parent.useResultsListFocusNavigationBindings)
local useResultsAreSduiEnabled = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useResultsAreSduiEnabled)
local FFlagAXFixCatalogRefreshRendering = AvatarExperienceFlags.FFlagAXFixCatalogRefreshRendering
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAXMigrateAXToGlobalAutofocus = SharedFlags.FFlagAXMigrateAXToGlobalAutofocus
local MarketplaceCatalogSduiSelectionBridge = require(CorePackages.Workspace.Packages.AvatarExperienceServerDrivenUi).MarketplaceCatalogSduiSelectionBridge
local FFlagAXAdaptiveScrollingFixForward = AvatarExperienceFlags.FFlagAXAdaptiveScrollingFixForward
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local OrganicTTIMilestoneManager = AvatarExperienceTTIPerformance.OrganicTTIMilestoneManager
local FFlagAXFixWidgetOnlyTabNoItemsFound = AvatarExperienceFlags.FFlagAXFixWidgetOnlyTabNoItemsFound
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagSduiMarketplaceCatalogSortSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiMarketplaceCatalogSortSupport
local v124 = if not FFlagSduiMarketplaceCatalogSortSupport then nil else require(script.Parent.CatalogPageMonolithDependenciesProvider)
local v125 = Roact.PureComponent:extend("ResultsList")

v125.defaultProps = {
	navBarSizeY = 0
}
v125.validateProps = t.strictInterface({
	analyticsContext = t.string,
	layoutOrder = t.optional(t.number),
	fromSearch = t.boolean,
	itemsHeader = t.optional(t.table),
	frameRef = t.optional(t.table),
	scrollingFrameRef = t.optional(t.table),
	onRetry = t.callback,
	searchUuid = t.string,
	navBarSizeY = t.optional(t.number),
	navBarRef = t.optional(t.table),
	backToTopSignal = t.optional(t.table),
	multiTryOnBottomBarRef = t.optional(t.table),
	categoryInfo = t.optional(t.table),
	onCategoryOrSubcategoryChange = t.optional(t.callback),
	onCategoryOrSubcategoryChangeById = t.optional(t.callback),
	itemDetailsPeekViewRefs = t.table,
	showCloseIcon = t.optional(t.boolean),
	onCloseFocusedWidget = t.optional(t.callback),
	NextSelectionUp = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	searchParameters = t.optional(t.table),
	searchInCatalog = t.optional(t.table),
	dataStatus = t.string,
	currentPage = t.optional(t.table),
	tryOnItems = t.optional(t.table),
	tryOnLookId = t.optional(t.string),
	fullView = t.optional(t.userdata),
	focusedWidget = t.optional(t.table),
	hideTopBar = t.optional(t.boolean),
	widgetRequestId = t.optional(t.string),
	selectedCategoryId = t.optional(t.string),
	selectedSubcategoryId = t.optional(t.string),
	selectedSearchCategoryId = t.optional(t.string),
	selectedSearchSubcategoryId = t.optional(t.string),
	selectedCategory = t.optional(t.table),
	selectedSearchCategory = t.optional(t.table),
	selectedSearchSubcategory = t.optional(t.table),
	widgetDataStatus = t.optional(t.string),
	hasWidgets = t.boolean,
	sortAndFilters = t.optional(t.table),
	externalNavigationRequestParams = t.table,
	itemInfos = t.table,
	analyticsMetadata = t.optional(t.table),
	filterCount = if not FFlagAXMoveAllTabToWidgetOnly then nil else t.number,
	dispatchLoadMore = t.callback,
	dispatchSetResultsListFocusedWidget = t.callback,
	dispatchClearResultsListFocusedWidget = t.callback,
	dispatchApplySduiFocusedSort = if not FFlagAXMigrateAllTabToSduiDev then nil else t.callback,
	dispatchClearSduiFocusedSort = if not FFlagAXMigrateAllTabToSduiDev then nil else t.callback,
	dispatchCatalogTilesLatencyStartTracker = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else t.callback,
	fetchItemData = t.callback,
	handleDeepLinkEquipError = t.callback,
	equipCatalogDeepLinkItem = t.callback,
	catalogAnalytics = t.table,
	axAnalytics = t.table,
	networking = t.callback,
	avatarRoute = AvatarRoute.Interface,
	namedRefs = t.table,
	navigation = t.table,
	adaptiveScrolling = t.optional(t.any),
	visibilityRatioBinding = if not FFlagAXHideMenuOnScroll then nil else t.optional(t.table),
	focusNavigationBindingsRef = if not FFlagAXMigrateMainNavigationInputBindings then nil else t.callback,
	tagBasedImpressionsDetectorExtensions = if not FFlagAXItemDetailsIxpExposure then nil else t.table,
	hasProcessedMarketplaceFetcher = if not FFlagAXMoveAllTabToWidgetOnly then nil else t.boolean,
	isFetchingMarketplaceError = if not FFlagAXMoveAllTabToWidgetOnly and not FFlagAXCatalogCategoriesSDUI then nil else t.boolean,
	shouldPageUseWidgetOnly = if not FFlagAXMoveAllTabToWidgetOnly then nil else t.boolean,
	showSduiResults = if not FFlagAXMigrateAllTabToSduiDev then nil else t.boolean,
	context = if not FFlagAXMigrateAllTabToSduiDev then nil else t.optional(t.string)
})

function v125.init(p1) -- line: 290
	-- upvalues: Roact (copy), Signal (copy), RetrievalStatus (copy), Promise (copy), v94 (copy), mutedError (copy), FFlagAXMigrateAllTabToSduiDev (copy), FilterUtils (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), OrganicTTIMilestoneManager (copy)
	p1.state = {
		restorePreviousChildFocus = true,
		numItemsPerRow = 0,
		navBarSizeY = 0,
		showFailedState = false
	}
	p1.lastYPosition = 0
	p1.scrollingFrameRef = p1.props.scrollingFrameRef or Roact.createRef()
	p1.navBarRef = Roact.createRef()
	p1.topPanelRef = Roact.createRef()
	p1.gridRef = Roact.createRef()
	p1.pillBarRef = Roact.createRef()
	p1.emptyStateRef = Roact.createRef()
	p1.widgetFlatListRef = Roact.createRef()
	p1.topPanelHeightBinding = nil
	p1.updateTopPanelHeightBinding = nil

	local v133, v134 = Roact.createBinding(0)

	p1.topPanelHeightBinding = v133
	p1.updateTopPanelHeightBinding = v134
	p1.impressionsReported = {}
	p1.itemDetailsPeekViewRefs = p1.props.itemDetailsPeekViewRefs

	function p1.onNumItemsPerRowChanged(p2) -- line: 314
		-- upvalues: p1 (copy)
		p1:setState({
			numItemsPerRow = p2
		})
	end
	function p1.onNavBarSizeChanged(p3) -- line: 320
		-- upvalues: p1 (copy)
		if p3.Y ~= p1.state.navBarSizeY then
			p1:setState({
				navBarSizeY = p3.Y
			})
		end
	end

	p1.requestImpressionsSignal = Signal.new()

	function p1.onItemsListScroll(n1: number) -- line: 330
		-- upvalues: p1 (copy)
		p1.requestImpressionsSignal:fire()

		local v291 = p1.props.adaptiveScrolling or {}

		if v291.onCanvasYChanged then
			v291.onCanvasYChanged(n1)
		end
	end
	function p1.loadMore() -- line: 339
		-- upvalues: p1 (copy), RetrievalStatus (copy), Promise (copy), v94 (copy), mutedError (copy)
		if p1.props.dataStatus == RetrievalStatus.Fetching then
			p1.retryLoadMore = true

			return Promise.resolve("Currently fetching")
		end

		local catalogAnalytics = p1.props.catalogAnalytics
		local searchUuid = p1.props.searchUuid
		local searchInCatalog = p1.props.searchInCatalog
		local searchParameters = p1.props.searchParameters
		local dispatchLoadMore = p1.props.dispatchLoadMore

		if v94 and not searchInCatalog then
			searchInCatalog = {}
			mutedError(string.format("ResultsList: searchInCatalog is nil; searchUuid: %s", (tostring(searchUuid))))
		end

		local v297 = searchParameters and searchParameters.categoryInfo or nil

		return dispatchLoadMore(catalogAnalytics, searchInCatalog.keyword, searchUuid, v297, p1.props.networking)
	end
	function p1.onFocusGained() -- line: 371
		-- upvalues: p1 (copy)
		p1:setState({
			restorePreviousChildFocus = true
		})
	end
	function p1.scrollBackToTop() -- line: 377
		-- upvalues: p1 (copy)
		local current = p1.props.scrollingFrameRef.current

		if current then
			current:ScrollToTop()
		end
	end
	function p1.setFocusedWidget(p4) -- line: 384
		-- upvalues: p1 (copy)
		local v300 = if not p4 or not p4.template then nil else p4.template.title
		local v301 = (not p4 or not p4.template) and "" or p4.template.localizedTitle
		local v302 = (not p4 or not p4.template) and "" or p4.template.localizedDescription
		local v303 = if not p4 or not p4.template then nil else p4.template.description
		local v304 = if not p4 or not p4.template then nil else p4.template.tooltip
		local v305 = (not p4 or not p4.template) and "" or p4.template.localizedTooltip
		local t1 = {
			title = v300,
			localizedTitle = v301,
			description = v303,
			localizedDescription = v302,
			tooltip = v304,
			localizedTooltip = v305
		}

		p1.props.dispatchSetResultsListFocusedWidget(p1.props.searchUuid, p4.id, t1)
	end
	function p1.clearFocusedWidget() -- line: 409
		-- upvalues: p1 (copy), FFlagAXMigrateAllTabToSduiDev (copy)
		p1.props.dispatchClearResultsListFocusedWidget(p1.props.searchUuid)

		if FFlagAXMigrateAllTabToSduiDev and p1.sduiFocusedSortContext then
			p1.props.dispatchClearSduiFocusedSort(p1.sduiFocusedSortContext)
			p1.sduiFocusedSortContext = nil
		end
	end
	function p1.shouldScrollBackToTopOfList(t2: {[any]: any}) -- line: 420
		-- upvalues: FilterUtils (copy)
		local searchChanged = t2.searchChanged
		local oldSortsAndFilter = t2.oldSortsAndFilter
		local newSortsAndFilter = t2.newSortsAndFilter

		return searchChanged or not FilterUtils.areSortAndFiltersEqual(oldSortsAndFilter, newSortsAndFilter)
	end

	if GetFFlagEnableCatalogTileLoadingLatency() then
		TTIPerformanceManager.Surface.Marketplace.Root.startTracking()
		OrganicTTIMilestoneManager.L2.primaryDataStarted()
		OrganicTTIMilestoneManager.L3.networkFetch()
		p1.props.dispatchCatalogTilesLatencyStartTracker(p1.props.searchUuid)
	end
end
function v125.getNextSelectionRight(p5, p6, p7) -- line: 440
	-- upvalues: AvatarScreen (copy), Cryo (copy)
	local NextSelectionRight = p5.props.NextSelectionRight

	if p6 == AvatarScreen.ItemDetails and p7 then
		return p5.itemDetailsPeekViewRefs[p7]
	end

	if p6 == AvatarScreen.LookDetails then
		return p5.props.namedRefs[AvatarScreen.LookDetails]
	end

	if p5.props.tryOnItems and not Cryo.isEmpty(p5.props.tryOnItems) and p6 ~= AvatarScreen.SortAndFilters and p5.props.multiTryOnBottomBarRef and p5.props.multiTryOnBottomBarRef:getValue() ~= nil then
		NextSelectionRight = p5.props.multiTryOnBottomBarRef
	end

	return NextSelectionRight
end
function v125.renderResultsList(p8, p9, p10) -- line: 462
	-- upvalues: FFlagAXMoveAllTabToWidgetOnly (copy), RetrievalStatus (copy), CatalogConstants (copy), FFlagAXFixWidgetOnlyTabNoItemsFound (copy), AvatarScreen (copy), Constants2 (copy), withLocalization (copy), ImpressionEnums (copy), Roact (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), AvatarExperienceScreenSizeImpressionsDetector (copy), WidgetConstants (copy), IXPService (copy), CollectionService (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), CatalogCategories (copy), FFlagAXCatalogOffersBannerEnabled (copy), FFlagAXHideMenuOnScroll (copy), Focusable (copy), FFlagEnableLeftNavOnConsole (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateMainNavigationInputBindings (copy), RoactGamepad (copy), SignalConnection (copy), React (copy), ResultsListCatalogOffersBanner (copy), FFlagAXMigrateCatalogResultListNavigationToMVVM (copy), CatalogResultListNavigationContainer (copy), ResultsListTopPanel (copy), FFlagLuaAppsDefaultSelection (copy), FFlagAXMigrateAllTabToSduiDev (copy), CatalogSduiFeedEntryPoint (copy), EmptyState (copy), WidgetList (copy), FFlagAXAdaptiveScrollingFixForward (copy), ResultsListListHeader (copy), FitTextLabel (copy), FFlagRenameDeprecatedUIBloxTokens (copy), TagBasedImpressionsDetector (copy)
	local searchInCatalog = p8.props.searchInCatalog
	local dataStatus = p8.props.dataStatus
	local v144 = if not FFlagAXMoveAllTabToWidgetOnly then nil else p8.props.shouldPageUseWidgetOnly
	local v145 = if not FFlagAXMoveAllTabToWidgetOnly then nil else v144 and p8.props.hasProcessedMarketplaceFetcher
	local key = p8.props.navigation.state.key
	local avatarRoute = p8.props.avatarRoute
	local name = avatarRoute.current.name
	local key2 = avatarRoute.current.key
	local entries = p8.state.entries
	local v151 = entries and #entries ~= 0
	local hasWidgets = p8.props.hasWidgets
	local widgetDataStatus = p8.props.widgetDataStatus
	local v154 = dataStatus == RetrievalStatus.Done and (not widgetDataStatus or widgetDataStatus == RetrievalStatus.Done)
	local u155 = entries and #entries or CatalogConstants.PageFetchLimit
	local u156 = not v154 or (v151 or (p8.props.hasWidgets or FFlagAXMoveAllTabToWidgetOnly and (v145 and p8.props.hasProcessedMarketplaceFetcher)))
	local v157 = nil

	if FFlagAXFixWidgetOnlyTabNoItemsFound then
		if v145 then
			v154 = p8.props.hasProcessedMarketplaceFetcher
		end

		v157 = v145 and (p8.props.hasProcessedMarketplaceFetcher and hasWidgets)
		u156 = not v154 or (v151 or (p8.props.hasWidgets or v157))
	end

	local v158 = searchInCatalog and searchInCatalog.hasMoreEntries or nil
	local v159 = v151 and v158
	local v160 = v151 and not v159 or (FFlagAXMoveAllTabToWidgetOnly and v145 or FFlagAXFixWidgetOnlyTabNoItemsFound and v157)
	local p9Font = p9.Font
	local BodyFont = p9Font.Body.Font
	local v163 = p9Font.BaseSize * p9Font.Body.RelativeSize
	local Theme = p9.Theme
	local TextMutedColor = Theme.TextMuted.Color
	local TextMutedTransparency = Theme.TextMuted.Transparency
	local v167 = name ~= AvatarScreen.ItemDetails and p10 ~= nil
	local u168 = nil
	local v169 = Constants2.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local u170 = not u156 and not hasWidgets

	if not FFlagAXFixWidgetOnlyTabNoItemsFound or not v145 then
		u170 = u170 and (entries and #entries == 0)
	end

	local u171 = nil
	local selectedCategory = p8.props.selectedCategory
	local selectedSearchCategory = p8.props.selectedSearchCategory
	local v174 = nil
	local v175 = nil

	if avatarRoute.opaque.name == AvatarScreen.Catalog and selectedCategory.LooksWidgetContextForOrganicContent ~= nil then
		v174 = true
	end

	if avatarRoute.opaque.name == AvatarScreen.CatalogSearch and selectedSearchCategory.LooksWidgetContextForOrganicContent ~= nil then
		v175 = true
	end

	if (v174 or v175) and entries and #entries == 0 and v158 then
		u171 = true
		u170 = false
		u155 = 0
	end

	local active = p8.props.focusedWidget.active
	local title = p8.props.focusedWidget.title
	local id = p8.props.focusedWidget.id
	local v179 = if not active then nil else title
	local t3 = {}
	local u181 = v160 or active

	return withLocalization({
		noItemsFound = "Feature.Catalog.Response.NoItemsFound",
		emptyText = "Feature.DisplayName.ErrorMessage.SomethingWentWrong",
		focusedWidgetTitle = if v179 == "" then nil else v179
	})(function(p11) -- line: 573
		-- upvalues: p8 (copy), name (copy), key2 (copy), ImpressionEnums (copy), u168 (ref), Roact (copy), OrganicEventImpressionsReporter (copy), key (copy), FStringAXImpressionsEventName (copy), v169 (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), AvatarExperienceScreenSizeImpressionsDetector (copy), WidgetConstants (copy), t3 (copy), IXPService (copy), CollectionService (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), CatalogCategories (copy), v151 (copy), FFlagAXCatalogOffersBannerEnabled (copy), FFlagAXHideMenuOnScroll (copy), Focusable (copy), FFlagEnableLeftNavOnConsole (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateMainNavigationInputBindings (copy), v167 (copy), RoactGamepad (copy), p10 (copy), SignalConnection (copy), Theme (copy), React (copy), ResultsListCatalogOffersBanner (copy), FFlagAXMigrateCatalogResultListNavigationToMVVM (copy), CatalogResultListNavigationContainer (copy), ResultsListTopPanel (copy), FFlagLuaAppsDefaultSelection (copy), FFlagAXMigrateAllTabToSduiDev (copy), CatalogSduiFeedEntryPoint (copy), EmptyState (copy), WidgetList (copy), entries (copy), u156 (ref), v159 (copy), u181 (ref), active (copy), id (copy), u155 (ref), FFlagAXAdaptiveScrollingFixForward (copy), ResultsListListHeader (copy), u170 (ref), FitTextLabel (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p9 (copy), v163 (copy), TextMutedColor (copy), TextMutedTransparency (copy), BodyFont (copy), u171 (ref), TagBasedImpressionsDetector (copy)
		local v312 = p8:getNextSelectionRight(name, key2)
		local v313 = if not p8.props.fromSearch then ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE else ImpressionEnums.MarketplaceSurfaceType.SEARCH

		u168 = Roact.createElement(OrganicEventImpressionsReporter, {
			eventName = "marketplaceOrganicFELog",
			impressionsSchema = "defaultItem",
			parentRef = p8.gridRef,
			pageFilter = function() -- line: 580
				-- upvalues: key (copy), key2 (copy)
				return key == key2
			end,
			onRequestImpressionsSignal = p8.requestImpressionsSignal,
			eventContext = FStringAXImpressionsEventName(),
			requestId = p8.props.widgetRequestId,
			impressionsTag = v169,
			searchUuid = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else p8.props.searchUuid,
			surface = v313,
			analyticsMetadata = p8.props.analyticsMetadata
		})

		local v314 = Roact.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
			parentRef = p8.gridRef,
			pageFilter = function() -- line: 596
				-- upvalues: key (copy), key2 (copy)
				return key == key2
			end,
			onRequestImpressionsSignal = p8.requestImpressionsSignal,
			filterImpressionFunc = function(p12) -- line: 600
				-- upvalues: WidgetConstants (copy), t3 (copy)
				local WidgetConstantsWidgetExposureMetadataAttributeKey = p12:GetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey)

				return WidgetConstantsWidgetExposureMetadataAttributeKey and not t3[WidgetConstantsWidgetExposureMetadataAttributeKey]
			end,
			onImpressionsDetected = function(p13) -- line: 604
				-- upvalues: WidgetConstants (copy), t3 (copy), IXPService (copy), p8 (copy)
				for _, v372 in p13 do
					local WidgetConstantsWidgetExposureMetadataAttributeKey = v372:GetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey)

					t3[WidgetConstantsWidgetExposureMetadataAttributeKey] = true
					IXPService:LogUserLayerExposure(WidgetConstantsWidgetExposureMetadataAttributeKey)

					local impressionsReported = p8.impressionsReported

					if not impressionsReported[v372.Name] then
						p8.props.catalogAnalytics.widgetInteractionV2({}, WidgetConstants.ActionType.IMPRESSION)
						impressionsReported[v372.Name] = true
					end
				end
			end,
			collectObjectsFunc = function(_) -- line: 619
				-- upvalues: CollectionService (copy), WidgetConstants (copy)
				return CollectionService:GetTagged(WidgetConstants.WidgetExposureMetadata.TagName)
			end
		})
		local frameRef = p8.props.frameRef
		local backToTopSignal = p8.props.backToTopSignal
		local v317 = p8.props.adaptiveScrolling or {}
		local n2 = 0

		if p8.props.multiTryOnBottomBarRef then
			local v319 = p8.props.multiTryOnBottomBarRef:getValue()

			n2 = not v319 and 0 or v319.AbsoluteSize.Y
		end

		local routeName = p8.props.navigation.state.routeName
		local v321 = p8.props.namedRefs[routeName .. "TopPanel"]
		local selectedSearchCategory2 = p8.props.selectedSearchCategory
		local v323 = ((if not FFlagAXRemoveCatalogCategoryNavKey then (if selectedSearchCategory2.NavigationKey == CatalogCategories.Avatars then (if not p8.props.selectedSearchSubcategory then selectedSearchCategory2 else p8.props.selectedSearchSubcategory) else (if not p8.props.selectedSearchSubcategory then selectedSearchCategory2 else p8.props.selectedSearchSubcategory)) else (if selectedSearchCategory2.Id == CatalogCategories.Avatars:rawValue() then (if not p8.props.selectedSearchSubcategory then selectedSearchCategory2 else p8.props.selectedSearchSubcategory) else (if not p8.props.selectedSearchSubcategory then selectedSearchCategory2 else p8.props.selectedSearchSubcategory)))).LooksWidgetContextForOrganicContent ~= nil
		local t4 = {
			fromSearch = p8.props.fromSearch,
			catalogAnalytics = p8.props.catalogAnalytics,
			axAnalytics = p8.props.axAnalytics,
			searchUuid = p8.props.searchUuid,
			searchInCatalog = p8.props.searchInCatalog,
			hideTopBar = p8.props.hideTopBar,
			focusedWidget = p8.props.focusedWidget,
			showCloseIcon = p8.props.showCloseIcon,
			restorePreviousChildFocus = p8.state.restorePreviousChildFocus,
			topPanelRef = p8.topPanelRef,
			gridRef = p8.gridRef,
			hasEntries = v151,
			backToTopSignal = p8.props.backToTopSignal,
			onCategoryOrSubcategoryChange = p8.props.onCategoryOrSubcategoryChange,
			onCategoryOrSubcategoryChangeById = p8.props.onCategoryOrSubcategoryChangeById,
			onCloseFocusedWidget = p8.props.onCloseFocusedWidget,
			hidePillBar = v323
		}

		if not FFlagAXCatalogOffersBannerEnabled then
			t4.updateHeightBinding = p8.updateTopPanelHeightBinding
		end

		local v325 = if not FFlagAXHideMenuOnScroll or not p8.props.visibilityRatioBinding then nil else Roact.joinBindings({
			visibility = p8.props.visibilityRatioBinding,
			height = p8.topPanelHeightBinding
		}):map(function(t5: {[any]: any}) -- line: 679
			local v377 = math.floor((1 - t5.visibility) * -t5.height)

			return UDim2.fromOffset(0, v377)
		end)
		local v326 = if not FFlagAXHideMenuOnScroll or not p8.props.visibilityRatioBinding then nil else Roact.joinBindings({
			visibility = p8.props.visibilityRatioBinding,
			height = p8.topPanelHeightBinding
		}):map(function(t6: {[any]: any}) -- line: 689
			local v379 = t6.height * t6.visibility

			return UDim2.new(1, 0, 1, -v379)
		end)
		local v327 = if not FFlagAXHideMenuOnScroll or not p8.props.visibilityRatioBinding then nil else Roact.joinBindings({
			visibility = p8.props.visibilityRatioBinding,
			height = p8.topPanelHeightBinding
		}):map(function(t7: {[any]: any}) -- line: 699
			local v381 = t7.height * t7.visibility

			return UDim2.fromOffset(0, v381)
		end)

		return Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ClipsDescendants = not FFlagEnableLeftNavOnConsole,
			LayoutOrder = p8.props.layoutOrder,
			[Roact.Ref] = frameRef,
			defaultChild = p8.topPanelRef,
			NextSelectionUp = p8.props.NextSelectionUp,
			restorePreviousChildFocus = p8.state.restorePreviousChildFocus,
			inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateMainNavigationInputBindings then v167 and {
				NavUp = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 718
					-- upvalues: p10 (copy), p8 (copy)
					p10.moveFocusTo(p8.props.NextSelectionUp)
				end)
			} or nil else nil
		}, {
			BackToTopSignal = if not backToTopSignal then nil else Roact.createElement(SignalConnection, {
				signal = backToTopSignal,
				callback = p8.scrollBackToTop
			}),
			ScrollPanel = Roact.createElement(if not FFlagAXMigrateMainNavigationInputBindings then Focusable.Frame else "Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ClipsDescendants = not FFlagEnableLeftNavOnConsole,
				[Roact.Ref] = if not FFlagAXMigrateMainNavigationInputBindings then nil else p8.props.focusNavigationBindingsRef
			}, {
				TopPanel = if not FFlagAXCatalogOffersBannerEnabled then Roact.createElement(Focusable.Frame, {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = v321,
					Position = if not FFlagAXHideMenuOnScroll then nil else v325
				}, Roact.createElement(if not FFlagAXMigrateCatalogResultListNavigationToMVVM then ResultsListTopPanel else CatalogResultListNavigationContainer, t4)) else Roact.createElement(Focusable.Frame, {
					BackgroundTransparency = Theme.BackgroundMuted.Transparency,
					BackgroundColor3 = Theme.BackgroundMuted.Color,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 2,
					ref = v321,
					Position = if not FFlagAXHideMenuOnScroll then nil else v325,
					[Roact.Change.AbsoluteSize] = function(p15) -- line: 750
						-- upvalues: p8 (copy)
						p8.updateTopPanelHeightBinding(p15.AbsoluteSize.Y)
					end
				}, {
					ListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 0)
					}),
					OffersBanner = if not FFlagAXCatalogOffersBannerEnabled or p8.props.hideTopBar == true then nil else Roact.createElement("Frame", {
						BorderSizePixel = 0,
						LayoutOrder = 0,
						BackgroundTransparency = Theme.BackgroundMuted.Transparency,
						BackgroundColor3 = Theme.BackgroundMuted.Color,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						OffersBanner = React.createElement(ResultsListCatalogOffersBanner)
					}),
					Navigation = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Content = Roact.createElement(if not FFlagAXMigrateCatalogResultListNavigationToMVVM then ResultsListTopPanel else CatalogResultListNavigationContainer, t4)
					})
				}),
				ListFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ref = if not FFlagLuaAppsDefaultSelection then nil else p8.props.defaultFocusRef,
					Size = FFlagAXHideMenuOnScroll and v326 or p8.topPanelHeightBinding:map(function(p16) -- line: 810
						return UDim2.new(1, 0, 1, -p16)
					end),
					Position = FFlagAXHideMenuOnScroll and v327 or p8.topPanelHeightBinding:map(function(p17) -- line: 815
						return UDim2.fromOffset(0, p17)
					end)
				}, if not FFlagAXMigrateAllTabToSduiDev or not p8.props.showSduiResults then if not p8.state.showFailedState then {
					WidgetList = Roact.createElement(WidgetList.WidgetList, {
						entries = entries,
						fromSearch = p8.props.fromSearch,
						bottomBarHeight = n2,
						showingEntries = u156,
						searchUuid = p8.props.searchUuid,
						loadMore = v159 and p8.loadMore or nil,
						hasMoreRows = v159,
						shouldCreateEndOfScrollElement = u181,
						itemDetailsPeekViewRefs = p8.itemDetailsPeekViewRefs,
						gridRef = p8.gridRef,
						flatListRef = p8.widgetFlatListRef,
						onScroll = p8.onItemsListScroll,
						focusedWidget = if not active then nil else id,
						onWidgetFocusAcquired = p8.setFocusedWidget,
						onWidgetFocusReleased = p8.clearFocusedWidget,
						requestImpressionsSignal = p8.requestImpressionsSignal,
						onNumItemsPerRowChanged = p8.onNumItemsPerRowChanged,
						NextSelectionRight = v312,
						NextSelectionUp = p8.topPanelRef,
						restorePreviousChildFocus = p8.state.restorePreviousChildFocus,
						onFocusGained = not p8.state.restorePreviousChildFocus and p8.onFocusGained or nil,
						numItemsExpected = u155,
						scrollingEnabled = if not v317.scrollingEnabledBinding then FFlagAXAdaptiveScrollingFixForward and true or v317.scrollingEnabled else v317.scrollingEnabledBinding:map(function(p18) -- line: 866
							return p18
						end),
						listHeaderComponent = Roact.createElement(ResultsListListHeader),
						pillBarVisible = not v323
					}),
					NoItemsFound = u170 and Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then p9.Tokens.Global.Space_400 else p9.Tokens.Size.Size_800),
						Text = p11.noItemsFound,
						TextSize = v163,
						TextColor3 = TextMutedColor,
						TextTransparency = TextMutedTransparency,
						Font = BodyFont
					}),
					AvatarsTabError = u171 and Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = p8.props.layoutOrder,
						Size = UDim2.fromScale(1, 1)
					}, {
						EmptyState = Roact.createElement(EmptyState, {
							onActivated = p8.loadMore,
							text = p11.emptyText,
							[Roact.Ref] = p8.emptyStateRef
						})
					})
				} else {
					EmptyState = Roact.createElement(EmptyState, {
						onActivated = p8.props.onRetry,
						text = p11.emptyText,
						[Roact.Ref] = p8.emptyStateRef
					})
				} else {
					SduiResults = React.createElement(CatalogSduiFeedEntryPoint, {
						context = p8.props.context or "",
						Size = UDim2.new(1, 0, 1, 0),
						ref = p8.gridRef
					})
				})
			}),
			ImpressionsReporter = u168,
			WidgetImpressionsReporter = v314,
			UnifiedImpressionsReporter = Roact.createElement(TagBasedImpressionsDetector, {
				parentRef = p8.gridRef,
				pageFilter = function() -- line: 920
					-- upvalues: key (copy), key2 (copy)
					return key == key2
				end,
				requestImpressionsSignal = p8.requestImpressionsSignal,
				extensions = p8.props.tagBasedImpressionsDetectorExtensions
			})
		})
	end)
end
function v125.render(p19) -- line: 930
	-- upvalues: withStyle (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy)
	return withStyle(function(p20) -- line: 931
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p19 (copy), RoactGamepad (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			return p19:renderResultsList(p20)
		end

		return RoactGamepad.withFocusController(function(p21) -- line: 935
			-- upvalues: p19 (copy), p20 (copy)
			return p19:renderResultsList(p20, p21)
		end)
	end)
end
function v125.updateItems(p22, p23) -- line: 948
	-- upvalues: FFlagAXMoveAllTabToWidgetOnly (copy), DeepLinkUtils (copy), ItemData (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), sendUnifiedEventLog (copy), CartIdService (copy), FFlagAXFixCatalogRefreshRendering (copy), Roact (copy), Cryo (copy), Constants (copy), FFlagAXMISEnableMultiShopping (copy), getTryOnItemReducerKey (copy)
	local searchInCatalog = p22.props.searchInCatalog
	local v186 = searchInCatalog and searchInCatalog.items or nil
	local v187 = not not FFlagAXMoveAllTabToWidgetOnly and p22.props.shouldPageUseWidgetOnly
	local v188 = if not FFlagAXMoveAllTabToWidgetOnly then nil else v187 and p22.props.hasProcessedMarketplaceFetcher
	local u189 = if not FFlagAXMoveAllTabToWidgetOnly or not v188 then v186 else {}

	if p22.props.externalNavigationRequestParams then
		if DeepLinkUtils.newValidEquipDeepLinkExists(p22.props.externalNavigationRequestParams) then
			local v190, v191 = DeepLinkUtils.parseItemIdAndItemType(p22.props.externalNavigationRequestParams)
			local v192 = ItemData(p22.props.itemInfos, v190, v191)

			if v192 then
				local v193 = DeepLinkUtils.parseItemSubType(v191, v192)

				if FFlagAXMISEnableMultiShoppingUnifiedEvents then
					local ASSET = nil

					if v191 == "Asset" then
						ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
					elseif v191 == "Bundle" then
						ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
					end

					sendUnifiedEventLog({
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
						cartId = CartIdService.getCartId(),
						itemId = v190,
						itemType = ASSET,
						assetType = if v191 ~= "Asset" then nil else v193,
						bundleType = if v191 ~= "Asset" then v193 else nil,
						organicItemPrice = v192.priceInRobux
					})
				end

				p22.props.equipCatalogDeepLinkItem(p22.props.networking, p22.props.catalogAnalytics, v191, v193, v190, true, p22.props.avatarRoute, p22.props.navigation, p22.props.widgetAnalyticsInfo)
			elseif not p22.props.externalNavigationRequestParams.wasItemEquipped then
				p22.props.fetchItemData(p22.props.networking, p22.props.catalogAnalytics, v190, v191):catch(function() -- line: 1006
					-- upvalues: p22 (copy), v190 (copy), v191 (copy), DeepLinkUtils (copy), u189 (ref)
					p22.props.handleDeepLinkEquipError(v190, v191)
					DeepLinkUtils.removeDeepLinkEntries(u189)
				end)
			end
		end

		if p22.props.externalNavigationRequestParams.wasItemEquipped then
			local tryOnItems = p22.props.tryOnItems
			local v196 = if not FFlagAXFixCatalogRefreshRendering or not p22.props.categoryInfo then nil else p22.props.categoryInfo
			local v197 = p22.props.searchParameters and p22.props.searchParameters.categoryInfo or (v196 or {})

			DeepLinkUtils.addEquippedItemToCatalogEntries(p22.props.externalNavigationRequestParams, tryOnItems, v197, u189)
		end
	end

	if not u189 then
		p22:setState({
			entries = Roact.None
		})

		return
	end

	local tryOnItems = p22.props.tryOnItems

	if p23 and not Cryo.isEmpty(tryOnItems) and ((not FFlagAXMoveAllTabToWidgetOnly or not v188) and p22.props.tryOnLookId == nil) then
		local v199 = p22.props.searchParameters and p22.props.searchParameters.categoryInfo or {}
		local t8 = {}
		local n3 = 0

		if v199.AssetTypeIdStrings then
			for _, v203 in v199.AssetTypeIdStrings do
				t8 = Cryo.Dictionary.join(t8, {
					[v203] = Constants.ItemType.Asset
				})
			end

			n3 += #v199.AssetTypeIdStrings
		end

		if v199.BundleTypes then
			for _, v205 in v199.BundleTypes do
				t8 = Cryo.Dictionary.join(t8, {
					[v205] = Constants.ItemType.Bundle
				})
			end

			n3 += #v199.BundleTypes
		end

		local t9 = table.create(#u189)

		if n3 > 0 then
			for _, v208 in tryOnItems do
				if (not FFlagAXMISEnableMultiShopping or not v208.lookId) and v208.itemSubType and t8[v208.itemSubType] == v208.itemType then
					table.insert(t9, {
						encryptedAdTrackingData = nil,
						id = tostring(v208.itemId),
						type = tostring(v208.itemType)
					})
				end
			end
		end

		for _, v210 in u189 do
			if not tryOnItems[getTryOnItemReducerKey(v210.id, v210.type)] then
				table.insert(t9, v210)
			end
		end

		p22:setState({
			entries = t9
		})
	elseif not Cryo.List.equals(p22.state.entries, u189) then
		p22:setState({
			entries = u189
		})
	end
end
function v125.didMount(p24) -- line: 1107
	-- upvalues: FFlagAXMigrateAllTabToSduiDev (copy), MarketplaceCatalogSduiSelectionBridge (copy)
	p24:updateItems(true)

	if FFlagAXMigrateAllTabToSduiDev then
		p24.sduiFocusedSortOwnerId = `ResultsList:{ tostring(p24) }`
		MarketplaceCatalogSduiSelectionBridge.registerFocusedSortHandler(p24.sduiFocusedSortOwnerId, function(p25) -- line: 1119
			-- upvalues: p24 (copy)
			if not p24.props.dispatchApplySduiFocusedSort(p25, p24.props.context, p24.props.networking) then
				return
			end

			p24.setFocusedWidget({
				id = p25.sortId,
				template = {
					localizedTitle = p25.title,
					localizedDescription = p25.description,
					localizedTooltip = p25.tooltipText
				}
			})
			p24.sduiFocusedSortContext = p24.props.context
		end)
	end
end
function v125.willUnmount(p26) -- line: 1145
	-- upvalues: FFlagAXMigrateAllTabToSduiDev (copy), MarketplaceCatalogSduiSelectionBridge (copy)
	if FFlagAXMigrateAllTabToSduiDev then
		if p26.sduiFocusedSortOwnerId then
			MarketplaceCatalogSduiSelectionBridge.unregisterFocusedSortHandler(p26.sduiFocusedSortOwnerId)
			p26.sduiFocusedSortOwnerId = nil
		end

		if p26.sduiFocusedSortContext then
			p26.props.dispatchClearSduiFocusedSort(p26.sduiFocusedSortContext)
			p26.sduiFocusedSortContext = nil
		end
	end
end
function v125.didUpdate(p27, p28, p29) -- line: 1160
	-- upvalues: RetrievalStatus (copy), FFlagAXMoveAllTabToWidgetOnly (copy), FFlagAXFixCatalogRefreshRendering (copy), Cryo (copy), FFlagAXCatalogCategoriesSDUI (copy), AvatarScreen (copy), Constants3 (copy)
	local v216 = p27.props.searchUuid ~= p28.searchUuid

	if p27.props.fromSearch then
		v216 = v216 or p28.categoryInfo ~= p27.props.categoryInfo or not p27.props.searchInCatalog
	end

	if v216 and p27.state.restorePreviousChildFocus ~= false then
		p27:setState({
			restorePreviousChildFocus = false
		})
	end

	if v216 or p27.state.numItemsPerRow ~= p29.numItemsPerRow then
		p27.requestImpressionsSignal:fire()
	end

	local v217 = p27.props.dataStatus == RetrievalStatus.Done and p28.dataStatus ~= RetrievalStatus.Done
	local v218 = if not FFlagAXMoveAllTabToWidgetOnly then nil else p27.props.hasProcessedMarketplaceFetcher
	local v219 = not not FFlagAXMoveAllTabToWidgetOnly and p27.props.shouldPageUseWidgetOnly
	local v220 = if not FFlagAXMoveAllTabToWidgetOnly then nil else v219 and v218
	local searchInCatalog = p27.props.searchInCatalog
	local v222 = searchInCatalog and searchInCatalog.items or nil

	if FFlagAXMoveAllTabToWidgetOnly and v220 and not v222 then
		v222 = {}
	end

	if FFlagAXFixCatalogRefreshRendering then
		local v223 = false

		if p27.props.externalNavigationRequestParams and p28.externalNavigationRequestParams then
			v223 = p27.props.externalNavigationRequestParams.wasItemEquipped ~= p28.externalNavigationRequestParams.wasItemEquipped
		elseif p27.props.externalNavigationRequestParams ~= p28.externalNavigationRequestParams then
			v223 = true
		end

		local v224 = p27.props.itemInfos ~= p28.itemInfos

		if FFlagAXMoveAllTabToWidgetOnly then
			local v225 = not Cryo.List.equals(p27.state.entries, v222)
			local v226 = p28.hasProcessedMarketplaceFetcher ~= p27.props.hasProcessedMarketplaceFetcher
			local v227 = v216 or v217

			if v223 or v224 or v227 and v225 or v226 and v225 then
				p27:updateItems(v216)
			end
		elseif v223 or v224 or (v216 or v217) and not Cryo.List.equals(p27.state.entries, v222) then
			p27:updateItems(v216)
		end
	else
		p27:updateItems(v216)
	end

	if p27.props.dataStatus == RetrievalStatus.Done and p28.dataStatus == RetrievalStatus.Fetching and p27.retryLoadMore then
		p27.retryLoadMore = false
		p27.loadMore()
	end

	if p27.shouldScrollBackToTopOfList({
		searchChanged = v216,
		oldSortsAndFilter = p28.sortAndFilters,
		newSortsAndFilter = p27.props.sortAndFilters
	}) and p27.widgetFlatListRef and p27.widgetFlatListRef.current then
		p27.widgetFlatListRef.current:scrollToOffset({
			offset = 0,
			animated = false
		})
	end

	local v228 = p27.props.dataStatus == RetrievalStatus.Failed
	local entries = p27.state.entries
	local v230 = entries and #entries ~= 0
	local v231 = v228 and not v230

	if FFlagAXCatalogCategoriesSDUI and p27.props.isFetchingMarketplaceError then
		v231 = p27.props.isFetchingMarketplaceError
	elseif FFlagAXMoveAllTabToWidgetOnly and p27.props.shouldPageUseWidgetOnly then
		v231 = p27.props.isFetchingMarketplaceError
	end

	if v231 ~= p29.showFailedState and v231 ~= p27.state.showFailedState then
		p27:setState({
			showFailedState = v231
		})

		if v231 then
			local catalogAnalytics = p27.props.catalogAnalytics

			if p27.props.navigation.state.routeName == AvatarScreen.CatalogSearch then
				catalogAnalytics.sendAXCounter(Constants3.Counter.Errors.NoInternetConnectionErrorSearchView)

				return
			end

			catalogAnalytics.sendAXCounter(Constants3.Counter.Errors.NoInternetConnectionErrorCatalogView)
		end
	end
end

local function mapStateToProps(p30, p31) -- line: 1312
	-- upvalues: Utils (copy), CatalogUtils (copy), Cryo (copy), FFlagAXMoveAllTabToWidgetOnly (copy), getAXMarketplaceWidgetStore (copy), PerformFetch (copy), FFlagAXFixWidgetOnlyTabNoItemsFound (copy), selectIsFullView (copy), AvatarScreen (copy), selectFilterCount (copy)
	local searchUuid = p31.searchUuid
	local categoryInfo = p31.categoryInfo
	local v237 = Utils.getSearchKey(p30, searchUuid)
	local v238 = false
	local v239 = nil
	local fromSearch = p31.fromSearch

	if searchUuid and fromSearch then
		local v241 = p30.SearchesParameters[searchUuid]
		local v242 = CatalogUtils.getQueryStringForSearchWidgets(v241)
		local v243 = p30.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[v242]

		if v243 then
			local Details = v243.Details

			v238 = not not (typeof(Details) == "table" and next(Details) ~= nil) and (Cryo.isEmpty(categoryInfo) or (categoryInfo.ShowWidgets or false))
		end

		local v246

		if FFlagAXMoveAllTabToWidgetOnly then
			local v245 = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)

			v246 = CatalogUtils.getFetchWidgetInfoFetchKey(v242, nil, v245)
		else
			v246 = CatalogUtils.getFetchWidgetInfoFetchKey(v242)
		end

		v239 = PerformFetch.GetStatus(p30, v246)
	elseif FFlagAXFixWidgetOnlyTabNoItemsFound and categoryInfo and p31.shouldPageUseWidgetOnly then
		local WidgetContext = categoryInfo.WidgetContext

		if WidgetContext then
			local v248 = p30.AvatarExperience.Common.Widgets.ContextWidgetInfo[WidgetContext]

			if v248 then
				v238 = typeof(v248.Details) == "table" and next(v248.Details) ~= nil
			end
		end
	end

	local v249 = p30.AvatarExperience.ExternalNavigationRequest.params or {}

	return {
		fullView = selectIsFullView(p30, AvatarScreen.Catalog),
		searchParameters = p30.SearchesParameters[p31.searchUuid],
		sortAndFilters = p30.AvatarExperience.Catalog.SortAndFilters,
		filterCount = if not FFlagAXMoveAllTabToWidgetOnly then nil else selectFilterCount(p30),
		searchInCatalog = p30.Search.SearchesInCatalog[p31.searchUuid],
		dataStatus = PerformFetch.GetStatus(p30, v237),
		tryOnItems = p30.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		tryOnLookId = p30.AvatarExperience.AvatarScene.OutfitTryOn.LookId,
		focusedWidget = p30.AvatarExperience.Catalog.ResultsList[p31.searchUuid] and p30.AvatarExperience.Catalog.ResultsList[p31.searchUuid].focusedWidget or {},
		hideTopBar = not not p30.AvatarExperience.Catalog.ResultsList[p31.searchUuid] and (p30.AvatarExperience.Catalog.ResultsList[p31.searchUuid].hideTopBar or false),
		widgetRequestId = p30.AvatarExperience.Common.Widgets.WidgetInfo.RequestId,
		widgetDataStatus = v239,
		hasWidgets = v238,
		externalNavigationRequestParams = v249,
		analyticsMetadata = p30.AvatarExperience.AnalyticsMetadata
	}
end
local function mapDispatchToProps(p32) -- line: 1380
	-- upvalues: FetchDataWithErrorToasts (copy), ApiFetchCatalogSearch (copy), SetResultsListFocusedWidget (copy), ClearResultsListFocusedWidget (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), CatalogTilesLatencyTracker (copy), FetchAssetOrBundleInfo (copy), ToggleTryOnThunk (copy), EquippedDeepLinkCatalogItem (copy), SetCurrentToastMessage (copy), ClearTryOns (copy)
	local v251 = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else function(p33) -- line: 1421
		-- upvalues: p32 (copy), CatalogTilesLatencyTracker (copy)
		return p32(CatalogTilesLatencyTracker.StartTracking(p33))
	end

	return {
		dispatchLoadMore = function(_, p35, p36, p37, p38) -- line: 1381
			-- upvalues: p32 (copy), FetchDataWithErrorToasts (copy), ApiFetchCatalogSearch (copy)
			return p32(FetchDataWithErrorToasts(ApiFetchCatalogSearch({
				searchKeyword = p35,
				searchUuid = p36,
				categoryInfo = p37
			}, p38)))
		end,
		dispatchSetResultsListFocusedWidget = function(p39, p40, p41) -- line: 1412
			-- upvalues: p32 (copy), SetResultsListFocusedWidget (copy)
			return p32(SetResultsListFocusedWidget(p39, p40, p41))
		end,
		dispatchClearResultsListFocusedWidget = function(p42) -- line: 1416
			-- upvalues: p32 (copy), ClearResultsListFocusedWidget (copy)
			return p32(ClearResultsListFocusedWidget(p42))
		end,
		dispatchCatalogTilesLatencyStartTracker = v251,
		fetchItemData = function(p43, p44, p45, p46) -- line: 1426
			-- upvalues: p32 (copy), FetchAssetOrBundleInfo (copy)
			return p32(FetchAssetOrBundleInfo(p43, p44, p45, p46))
		end,
		handleDeepLinkEquipError = function(p47, p48) -- line: 1463
			-- upvalues: p32 (copy), SetCurrentToastMessage (copy), EquippedDeepLinkCatalogItem (copy), ClearTryOns (copy)
			p32(SetCurrentToastMessage({
				toastMessage = "Feature.Avatar.Message.DeepLinkEquipFailed"
			}))
			p32(EquippedDeepLinkCatalogItem({
				wasItemEquipped = false,
				fetchItemFailed = true,
				itemId = p47,
				itemType = p48
			}))
			p32(ClearTryOns())
		end,
		equipCatalogDeepLinkItem = function(p49, p50, p51, p52, p53, p54, p55, p56, p57) -- line: 1430
			-- upvalues: p32 (copy), ToggleTryOnThunk (copy), EquippedDeepLinkCatalogItem (copy)
			p32(ToggleTryOnThunk(p49, p50, p51, p52, p53, p54, p55, p56, p57, true))
			p32(EquippedDeepLinkCatalogItem({
				wasItemEquipped = true,
				fetchItemFailed = false,
				itemId = p53,
				itemType = p51
			}))
		end
	}
end

local v128 = withNamedRefs((withAvatarRoute((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v125)))))
local u129 = withAdaptiveScrolling((withNavigation((RoactServices.connect({
	axAnalytics = Analytics,
	catalogAnalytics = Analytics2,
	networking = RoactNetworking
})(v128)))))

local function selectItemInfos(p58) -- line: 1501
	local AssetInfos = p58.AvatarExperience.Common.AssetInfos
	local BundleInfos = p58.AvatarExperience.Common.BundleInfos

	return {
		AssetInfos = AssetInfos,
		BundleInfos = BundleInfos
	}
end
local function ResultsListWrapper(t10: {[any]: any}) -- line: 1552
	-- upvalues: FFlagAXMigrateMainNavigationInputBindings (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useDispatch (copy), RoactGamepad (copy), useFocusGuiObject (copy), useSelector (copy), React (copy), ClearResultsListFocusedWidget (copy), useResultsListFocusNavigationBindings (copy), FFlagAXItemDetailsIxpExposure (copy), useUnifiedEventImpressionsReporter (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), FFlagAXHideMenuOnScroll (copy), useAnimatedVisibility (copy), SignalsReact (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXMoveAllTabToWidgetOnly (copy), Stores (copy), getUseSelectorDeepEquals (copy), selectFilterCount (copy), getShouldPageUseWidgetOnlyFetcher (copy), selectItemInfos (copy), tutils (copy), FFlagAXMigrateAllTabToSduiDev (copy), useResultsAreSduiEnabled (copy), useStore (copy), useApplySduiFocusedSort (copy), SetWidgetInfo (copy), SetHydratedWidgetData (copy), WebApi (copy), useClearSduiFocusedSort (copy), ClearWidgetInfo (copy), FFlagSduiMarketplaceCatalogSortSupport (copy), v124 (copy), u129 (ref)
	local v256 = table.clone(t10)

	if FFlagAXMigrateMainNavigationInputBindings then
		local v257 = nil

		if FFlagAXMigrateAXToGlobalAutofocus then
			function v257(p59) -- line: 1559
				return p59.AvatarExperience.Catalog.ResultsList
			end
		end

		local u258 = nil

		if FFlagAXMigrateAXToGlobalAutofocus then
			u258 = useDispatch()
		end

		local v259 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
		local v260 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useFocusGuiObject()
		local u261 = nil

		if FFlagAXMigrateAXToGlobalAutofocus then
			local v262 = useSelector(v257)
			local v263 = v262[t10.searchUuid] and v262[t10.searchUuid].focusedWidget

			u261 = not not v263 and v263.active
		end

		local v264 = React.useCallback(function(p60) -- line: 1578
			-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), u261 (ref), u258 (ref), ClearResultsListFocusedWidget (copy), t10 (copy), v260 (copy), v259 (copy)
			p60.cancelled = true

			if FFlagAXMigrateAXToGlobalAutofocus then
				if u261 then
					u258(ClearResultsListFocusedWidget(t10.searchUuid))

					if type(t10.onCloseFocusedWidget) == "function" then
						t10.onCloseFocusedWidget()

						return
					end
				elseif v260 and t10.NextSelectionUp and t10.NextSelectionUp.current then
					v260(t10.NextSelectionUp.current)

					return
				end
			else
				v259.moveFocusTo(t10.NextSelectionUp)
			end
		end, {
			if not FFlagAXMigrateAXToGlobalAutofocus then v259 else v260,
			t10.NextSelectionUp,
			if not FFlagAXMigrateAXToGlobalAutofocus then nil else u261,
			if not FFlagAXMigrateAXToGlobalAutofocus then nil else t10.searchUuid,
			if not FFlagAXMigrateAXToGlobalAutofocus then nil else u258,
			if not FFlagAXMigrateAXToGlobalAutofocus then nil else t10.onCloseFocusedWidget
		})

		v256.focusNavigationBindingsRef = useResultsListFocusNavigationBindings({
			onNavigateBack = v264
		}, t10.frameRef)
	end

	if FFlagAXItemDetailsIxpExposure then
		local v265 = useUnifiedEventImpressionsReporter()

		v256.tagBasedImpressionsDetectorExtensions = React.useMemo(function() -- line: 1610
			-- upvalues: v265 (copy)
			return { v265 }
		end, { v265 })
	end

	local v266 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v267 = useSignalState(v266.selectedCategoryId)
	local v268 = useSignalState(v266.selectedSubcategoryId)

	v256.selectedCategoryId = v267
	v256.selectedSubcategoryId = v268

	local v269 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local v270 = useSignalState(v269.selectedCategoryId)
	local v271 = useSignalState(v269.selectedSubcategoryId)

	v256.selectedSearchCategoryId = v270
	v256.selectedSearchSubcategoryId = v271

	local v272 = useSignalState(v266.selectedCategory)

	v256.selectedCategory = v272

	local v273 = useSignalState(v269.selectedCategory)

	v256.selectedSearchCategory = v273
	v256.selectedSearchSubcategory = useSignalState(v269.selectedSubcategory)

	local v274 = if not t10.fromSearch then v272 else v273

	v256.categoryInfo = v274

	if FFlagAXHideMenuOnScroll then
		local v275 = useAnimatedVisibility()

		v256.visibilityRatioBinding = if not v275 then React.createBinding(1) else SignalsReact.useSignalBinding(v275.animatedMenusStore.getVisibilityRatio)
	end

	if FFlagAXCatalogCategoriesSDUI or FFlagAXMoveAllTabToWidgetOnly then
		local v276 = Stores.getFetchMarketplaceStore(false)
		local v277 = useSignalState(v276.getFetchingMarketplaceError)
		local v278 = if not FFlagAXCatalogCategoriesSDUI then nil else useSignalState(v276.getCatalogCategoriesError)

		v256.isFetchingMarketplaceError = v277

		if FFlagAXCatalogCategoriesSDUI then
			v256.isFetchingMarketplaceError = v277 or v278
		end

		if FFlagAXMoveAllTabToWidgetOnly then
			v256.hasProcessedMarketplaceFetcher = useSignalState(v276.getFetchingMarketplaceProcessed)

			local v279 = React.useCallback(function(p61) -- line: 1673
				-- upvalues: t10 (copy)
				return p61.SearchesParameters[t10.searchUuid]
			end, { t10.searchUuid })
			local v280 = useSelector(v279, getUseSelectorDeepEquals())
			local v281 = useSelector(selectFilterCount)

			v256.shouldPageUseWidgetOnly = getShouldPageUseWidgetOnlyFetcher(v256.categoryInfo, v281, v280 and v280.searchKeyword)
		end
	end

	v256.itemInfos = useSelector(selectItemInfos, tutils.shallowEqual)

	if FFlagAXMigrateAllTabToSduiDev then
		local v282 = React.useCallback(function(p62) -- line: 1694
			-- upvalues: t10 (copy)
			local v367 = p62.AvatarExperience.Catalog.ResultsList[t10.searchUuid]

			return not not v367 and (not not v367.focusedWidget and (v367.focusedWidget.active or false))
		end, { t10.searchUuid })
		local v283 = useSelector(v282)
		local v284 = useResultsAreSduiEnabled() and not v283
		local v285 = v274 and v274.WidgetContext or ""

		v256.showSduiResults = v284
		v256.context = v285

		local v286 = useStore()
		local v287 = React.useCallback(function() -- line: 1731
			-- upvalues: v286 (copy)
			return v286:getState().AvatarExperience.Common.Widgets.HydratedWidgetData
		end, { v286 })

		v256.dispatchApplySduiFocusedSort = useApplySduiFocusedSort({
			SetWidgetInfo = SetWidgetInfo,
			SetHydratedWidgetData = SetHydratedWidgetData,
			CatalogWebApi = WebApi,
			getHydratedWidgetData = v287
		})
		v256.dispatchClearSduiFocusedSort = useClearSduiFocusedSort({
			ClearWidgetInfo = ClearWidgetInfo
		})
	end

	if FFlagSduiMarketplaceCatalogSortSupport then
		return React.createElement(v124, nil, React.createElement(u129, v256))
	end

	return React.createElement(u129, v256)
end

return ResultsListWrapper
