local CorePackages = game:GetService("CorePackages")
local CollectionService = game:GetService("CollectionService")
local IXPService = game:GetService("IXPService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local module = require("@luauforge/bundled/eda")
local module2 = require("@luauforge/bundled/dCh")
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local emptyState = UIBlox.App.Indicator.EmptyState
local withStyle = UIBlox.Style.withStyle
local Promise = require(CorePackages.Packages.Promise)
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local t = require(CorePackages.Packages.t)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitTextLabel = AvatarExperienceDeps.RoactFitComponents.FitTextLabel
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Cryo = require(CorePackages.Packages.Cryo)
local module3 = require("@luauforge/bundled/dCn")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module6 = require("@luauforge/bundled/dMd")
local module7 = require("@luauforge/deferred/gQI")
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local module9 = require("@luauforge/bundled/dPG")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
require("@luauforge/bundled/dHK")
local module10 = require("@luauforge/bundled/dSV")
require("@luauforge/bundled/dRX")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module12 = require("@luauforge/bundled/dxy")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useStore = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useStore
local tutils = require(CorePackages.Packages.tutils)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local module13 = require("@luauforge/bundled/fsK")
local module14 = require("@luauforge/bundled/dMx")
local module15 = require("@luauforge/bundled/fuD")
local module16 = require("@luauforge/bundled/glS")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module17 = require("@luauforge/bundled/dwA")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module18 = require("@luauforge/bundled/fvF")
local module19 = require("@luauforge/bundled/dME")
local module20 = require("@luauforge/bundled/gNM")
local module21 = require("@luauforge/bundled/fuC")
local module22 = require("@luauforge/bundled/fvZ")
local GetGameName = require("@game/CoreGui/RobloxGui/Modules/AvatarEditorPrompts/Thunks/GetGameName")
local module24 = require("@luauforge/bundled/fsJ")
local module25 = require("@luauforge/deferred/ggF")
local module26 = require("@luauforge/deferred/gTE")
local module27 = require("@luauforge/bundled/goe")
local module28 = require("@luauforge/bundled/gOc")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local catalogSduiFeedEntryPoint = AvatarExperienceCatalog.Components.CatalogSduiFeedEntryPoint
local useApplySduiFocusedSort = AvatarExperienceCatalog.Sdui.useApplySduiFocusedSort
local useClearSduiFocusedSort = AvatarExperienceCatalog.Sdui.useClearSduiFocusedSort
local resolveSduiFocusedSortContext = AvatarExperienceCatalog.Sdui.resolveSduiFocusedSortContext
local getCatalogPageIdentifier = AvatarExperienceCatalog.Sdui.getCatalogPageIdentifier
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore

local module29 = require("@luauforge/bundled/dRQ")
require("@luauforge/bundled/dSt")
local module30 = require("@luauforge/bundled/fuL")

local module31 = require("@luauforge/deferred/gUj")
local module32 = require("@luauforge/deferred/gUk")

local module33 = require("@luauforge/deferred/gUz")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module34 = require("@luauforge/bundled/gNx")

local avatarExperienceScreenSizeImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceScreenSizeImpressionsDetector
local catalogCategories = module6.Enums.CatalogCategories

local tagBasedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").TagBasedImpressionsDetector

local useUnifiedEventImpressionsReporter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").useUnifiedEventImpressionsReporter
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventLog
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums
local useAnimatedVisibility = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.useAnimatedVisibility
local getShouldPageUseWidgetOnlyFetcher = AvatarExperienceCatalog.Utils.getShouldPageUseWidgetOnlyFetcher
local useOnRequestImpressionsSignal = AvatarExperienceCatalog.Hooks.useOnRequestImpressionsSignal
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local cartIdService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Lib.CartIdService

local module35 = require("@luauforge/deferred/gPr")

local module36 = require("@luauforge/bundled/dSS")
local module37 = require("@luauforge/bundled/dST")
local module38 = require("@luauforge/bundled/dNG")
local module39 = require("@luauforge/bundled/dNH")
local module40 = require("@luauforge/bundled/dMP")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module42 = require("@luauforge/bundled/dMs")
local clearTryOns = require("@luauforge/bundled/dHL").Actions.ClearTryOns
local defineFastFlag = game:DefineFastFlag("AXFixResultListCrash", false)
local module43 = require("@luauforge/bundled/dMx")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents

local fFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics

local reportVisibleUpsellImpression = module7.BackgroundsPlusAnalytics.reportVisibleUpsellImpression

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2

local module44 = require("@luauforge/deferred/gPl")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local seenImpressionsStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Store.SeenImpressionsStore

local module45 = require("@luauforge/deferred/gUE")

local module46 = require("@luauforge/bundled/gOb")
local fFlagAXFixCatalogRefreshRendering = AvatarExperienceFlags.FFlagAXFixCatalogRefreshRendering

local marketplaceCatalogSduiSelectionBridge = require("@luauforge/bundled/dPP").MarketplaceCatalogSduiSelectionBridge

local fFlagAXAdaptiveScrollingFixForward = AvatarExperienceFlags.FFlagAXAdaptiveScrollingFixForward

local fFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll

local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local module47 = require("@luauforge/bundled/ggZ")
local ttiPerformanceManager = module47.TTIPerformanceManager
local organicTTIMilestoneManager = module47.OrganicTTIMilestoneManager
local fFlagAXFixWidgetOnlyTabNoItemsFound = AvatarExperienceFlags.FFlagAXFixWidgetOnlyTabNoItemsFound
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXSduiSeeAllPageRequestId = AvatarExperienceFlags.FFlagAXSduiSeeAllPageRequestId
local fFlagAXSduiFeedMaintainScrollOnSeeAll = AvatarExperienceFlags.FFlagAXSduiFeedMaintainScrollOnSeeAll
local fFlagAXSharedImpressionRescan = AvatarExperienceFlags.FFlagAXSharedImpressionRescan
local fFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local fFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled

local fFlagSduiMarketplaceCatalogSortSupport = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSduiMarketplaceCatalogSortSupport

local v5 = if fFlagSduiMarketplaceCatalogSortSupport then require("@luauforge/deferred/gPu") else nil

local extended = Roact.PureComponent:extend("ResultsList")
extended.defaultProps = { navBarSizeY = 0 }

local strictInterface = t.strictInterface
local v6 = {}
v6.analyticsContext = t.string
v6.layoutOrder = t.optional(t.number)
v6.fromSearch = t.boolean
v6.itemsHeader = t.optional(t.table)
v6.frameRef = t.optional(t.table)
v6.scrollingFrameRef = t.optional(t.table)
v6.onRetry = t.callback
v6.searchUuid = t.string
v6.navBarSizeY = t.optional(t.number)
v6.navBarRef = t.optional(t.table)
v6.backToTopSignal = t.optional(t.table)
v6.multiTryOnBottomBarRef = t.optional(t.table)
v6.categoryInfo = t.optional(t.table)
v6.onCategoryOrSubcategoryChange = t.optional(t.callback)
v6.onCategoryOrSubcategoryChangeById = t.optional(t.callback)
v6.itemDetailsPeekViewRefs = t.table
v6.scrollPerformanceIntervalName = t.optional(t.string)

v6.showCloseIcon = t.optional(t.boolean)
v6.onCloseFocusedWidget = t.optional(t.callback)

v6.NextSelectionUp = t.optional(t.table)
v6.NextSelectionRight = t.optional(t.table)
v6.defaultFocusRef = t.optional(t.callback)

v6.searchParameters = t.optional(t.table)
v6.searchInCatalog = t.optional(t.table)
v6.dataStatus = t.string
v6.currentPage = t.optional(t.table)
v6.tryOnItems = t.optional(t.table)
v6.tryOnLookId = t.optional(t.string)
v6.fullView = t.optional(t.userdata)
v6.focusedWidget = t.optional(t.table)
v6.hideTopBar = t.optional(t.boolean)
v6.widgetRequestId = t.optional(t.string)

v6.selectedCategoryId = t.optional(t.string)
v6.selectedSubcategoryId = t.optional(t.string)
v6.selectedSearchCategoryId = t.optional(t.string)
v6.selectedSearchSubcategoryId = t.optional(t.string)

v6.selectedCategory = t.optional(t.table)
v6.selectedSearchCategory = t.optional(t.table)
v6.selectedSearchSubcategory = t.optional(t.table)

v6.widgetDataStatus = t.optional(t.string)
v6.hasWidgets = t.boolean
v6.sortAndFilters = t.optional(t.table)
v6.externalNavigationRequestParams = t.table
v6.itemInfos = t.table
v6.analyticsMetadata = t.optional(t.table)
local v7 = if fFlagAXMoveAllTabToWidgetOnly then t.number else nil
v6.filterCount = v7

v6.dispatchLoadMore = t.callback
v6.dispatchSetResultsListFocusedWidget = t.callback
v6.dispatchClearResultsListFocusedWidget = t.callback

local v8 = if fFlagAXMigrateAllTabToSduiDev then t.callback else nil
v6.dispatchApplySduiFocusedSort = v8
local v9 = if fFlagAXMigrateAllTabToSduiDev then t.callback else nil
v6.dispatchClearSduiFocusedSort = v9
v6.dispatchCatalogTilesLatencyStartTracker = t.callback
v6.fetchItemData = t.callback
v6.handleDeepLinkEquipError = t.callback
v6.equipCatalogDeepLinkItem = t.callback

v6.catalogAnalytics = t.table
v6.axAnalytics = t.table
v6.networking = t.callback

v6.avatarRoute = avatarRoute.Interface

v6.namedRefs = t.table

v6.navigation = t.table

v6.adaptiveScrolling = t.optional(t.any)

local v10 = if fFlagAXHideMenuOnScroll then t.optional(t.table) else nil
v6.visibilityRatioBinding = v10

v6.focusNavigationBindingsRef = t.callback
local v11 = if fFlagAXSharedImpressionRescan then t.optional(t.table) else nil
v6.requestImpressionsSignal = v11
local v12 = if fFlagAXItemDetailsIxpExposure then t.table else nil
v6.tagBasedImpressionsDetectorExtensions = v12

local v13 = if fFlagAXMoveAllTabToWidgetOnly then t.boolean else nil
v6.hasProcessedMarketplaceFetcher = v13

local v14 = if fFlagAXMoveAllTabToWidgetOnly or fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then t.boolean else nil
v6.isFetchingMarketplaceError = v14

local v15 = if fFlagAXMoveAllTabToWidgetOnly then t.boolean else nil
v6.shouldPageUseWidgetOnly = v15
local v16 = if fFlagAXMigrateAllTabToSduiDev then t.boolean else nil
v6.showSduiResults = v16
local v17 = if fFlagAXMigrateAllTabToSduiDev then t.optional(t.string) else nil
v6.context = v17
extended.validateProps = strictInterface(v6)

function extended:init()
	self.state = {
		restorePreviousChildFocus = true,
		numItemsPerRow = 0,
		navBarSizeY = 0,
		showFailedState = false
	}

	self.lastYPosition = 0
	self.scrollingFrameRef = self.props.scrollingFrameRef or Roact.createRef()
	self.navBarRef = Roact.createRef()
	self.topPanelRef = Roact.createRef()

	self.gridRef = Roact.createRef()
	self.pillBarRef = Roact.createRef()
	self.emptyStateRef = Roact.createRef()
	self.widgetFlatListRef = Roact.createRef()
	self.topPanelHeightBinding = nil
	self.updateTopPanelHeightBinding = nil
	local binding, v18 = Roact.createBinding(0)
	self.topPanelHeightBinding = binding
	self.updateTopPanelHeightBinding = v18
	self.impressionsReported = {}

	self.itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs

	function self.onNumItemsPerRowChanged(p2)
		self:setState({ numItemsPerRow = p2 })
	end

	function self.onNavBarSizeChanged(p2)
		if p2.Y ~= self.state.navBarSizeY then
			self:setState({ navBarSizeY = p2.Y })
		end
	end

	if fFlagAXSharedImpressionRescan and self.props.requestImpressionsSignal ~= nil then
		self.requestImpressionsSignal = self.props.requestImpressionsSignal
	else
		self.requestImpressionsSignal = signal.new()
	end

	self.sduiFeedScrollPositionRef = { current = nil }
	self.sduiFeedScrollRestoreRefs = {}

	function self.onItemsListScroll(p2)
		self.requestImpressionsSignal:fire()

		local adaptiveScrolling = self.props.adaptiveScrolling or {}

		if adaptiveScrolling.onCanvasYChanged then
			adaptiveScrolling.onCanvasYChanged(p2)
		end
	end

	function self.loadMore()
		if self.props.dataStatus == module12.Fetching then
			self.retryLoadMore = true
			return Promise.resolve("Currently fetching")
		end

		local catalogAnalytics = self.props.catalogAnalytics
		local searchUuid = self.props.searchUuid
		local v19 = self.props.searchInCatalog
		local searchParameters = self.props.searchParameters
		local dispatchLoadMore = self.props.dispatchLoadMore

		if defineFastFlag and not v19 then
			module3(string.format(
				"ResultsList: searchInCatalog is nil; searchUuid: %s",
				(tostring(searchUuid))
			))
			v19 = {}
		end

		local categoryInfo = searchParameters and searchParameters.categoryInfo or nil
		return dispatchLoadMore(
			catalogAnalytics,
			v19.keyword,
			searchUuid,
			categoryInfo,
			self.props.networking
		)
	end

	function self.onFocusGained()
		self:setState({ restorePreviousChildFocus = true })
	end

	function self.scrollBackToTop()
		local current = self.props.scrollingFrameRef.current

		if current then
			current:ScrollToTop()
		end
	end

	function self.setFocusedWidget(p2)
		local title = if p2 and p2.template then p2.template.title else nil

		local v19 = not (p2 and p2.template) and "" or p2.template.localizedTitle
		local v20 = not (p2 and p2.template) and "" or p2.template.localizedDescription

		local description = if p2 and p2.template then p2.template.description else nil

		local tooltip = if p2 and p2.template then p2.template.tooltip else nil
		local v21 = not (p2 and p2.template) and "" or p2.template.localizedTooltip

		self.props.dispatchSetResultsListFocusedWidget(self.props.searchUuid, p2.id, {
			title = title,
			localizedTitle = v19,
			description = description,
			localizedDescription = v20,
			tooltip = tooltip,
			localizedTooltip = v21
		})
	end

	function self.clearFocusedWidget()
		self.props.dispatchClearResultsListFocusedWidget(self.props.searchUuid)

		if fFlagAXMigrateAllTabToSduiDev and self.sduiFocusedSortContext then
			self.props.dispatchClearSduiFocusedSort(self.sduiFocusedSortContext)
			self.sduiFocusedSortContext = nil
		end
	end

	function self.shouldScrollBackToTopOfList(data)
		local searchChanged = data.searchChanged
		local oldSortsAndFilter = data.oldSortsAndFilter
		local newSortsAndFilter = data.newSortsAndFilter
		return searchChanged or not module30.areSortAndFiltersEqual(oldSortsAndFilter, newSortsAndFilter)
	end

	ttiPerformanceManager.Surface.Marketplace.Root.startTracking()
	organicTTIMilestoneManager.L2.primaryDataStarted()
	organicTTIMilestoneManager.L3.networkFetch()
	self.props.dispatchCatalogTilesLatencyStartTracker(self.props.searchUuid)
end

function extended:getNextSelectionRight(p3, p4)
	local v18 = self.props.NextSelectionRight

	if p3 == avatarScreen.ItemDetails and p4 then
		return self.itemDetailsPeekViewRefs[p4]
	end

	if p3 == avatarScreen.LookDetails then
		return self.props.namedRefs[avatarScreen.LookDetails]
	end

	if
		self.props.tryOnItems
		and not Cryo.isEmpty(self.props.tryOnItems)
		and p3 ~= avatarScreen.SortAndFilters
		and self.props.multiTryOnBottomBarRef
		and self.props.multiTryOnBottomBarRef:getValue() ~= nil
	then
		v18 = self.props.multiTryOnBottomBarRef
	end

	return v18
end

function extended:renderResultsList(data)
	local searchInCatalog = self.props.searchInCatalog
	local dataStatus = self.props.dataStatus

	local shouldPageUseWidgetOnly = if fFlagAXMoveAllTabToWidgetOnly then self.props.shouldPageUseWidgetOnly else nil
	local hasProcessedMarketplaceFetcher

	if fFlagAXMoveAllTabToWidgetOnly then
		hasProcessedMarketplaceFetcher = shouldPageUseWidgetOnly
			and self.props.hasProcessedMarketplaceFetcher
	end

	local key = self.props.navigation.state.key
	local avatarRoute2 = self.props.avatarRoute
	local name = avatarRoute2.current.name
	local key2 = avatarRoute2.current.key

	local fn = fFlagAXUnifiedImpressionsOnThumbnail and function(): boolean
		return key == key2 or key == avatarRoute2.opaque.key
	end or nil

	local entries = self.state.entries
	local v18 = entries and #entries ~= 0

	local hasWidgets = self.props.hasWidgets
	local widgetDataStatus = self.props.widgetDataStatus
	local v19

	if dataStatus == module12.Done then
		v19 = not widgetDataStatus or widgetDataStatus == module12.Done
	else
		v19 = false
	end

	local v20 = entries and #entries or module19.PageFetchLimit

	local v21 = not v19
		or v18
		or self.props.hasWidgets
		or fFlagAXMoveAllTabToWidgetOnly
		and hasProcessedMarketplaceFetcher
		and self.props.hasProcessedMarketplaceFetcher
	local v22

	if fFlagAXFixWidgetOnlyTabNoItemsFound then
		if hasProcessedMarketplaceFetcher then
			v19 = self.props.hasProcessedMarketplaceFetcher
		end

		v22 = hasProcessedMarketplaceFetcher and self.props.hasProcessedMarketplaceFetcher and hasWidgets
		v21 = not v19 or v18 or self.props.hasWidgets or v22
	end

	local hasMoreEntries = searchInCatalog and searchInCatalog.hasMoreEntries or nil
	local v23 = v18 and hasMoreEntries

	local font = data.Font
	local font2 = font.Body.Font
	local v25 = font.BaseSize * font.Body.RelativeSize

	local theme = data.Theme
	local color = theme.TextMuted.Color
	local transparency = theme.TextMuted.Transparency

	local v26 = nil
	local v27 = module17.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v28 = not (v21 or hasWidgets)

	if not (fFlagAXFixWidgetOnlyTabNoItemsFound and hasProcessedMarketplaceFetcher) then
		v28 = v28 and entries and #entries == 0
	end

	local v29 = nil
	local selectedCategory = self.props.selectedCategory
	local selectedSearchCategory = self.props.selectedSearchCategory

	local v30 = avatarRoute2.opaque.name == avatarScreen.Catalog
		and selectedCategory.LooksWidgetContextForOrganicContent ~= nil
		or nil

	local v31 = avatarRoute2.opaque.name == avatarScreen.CatalogSearch
		and selectedSearchCategory.LooksWidgetContextForOrganicContent ~= nil
		or nil

	if (v30 or v31) and entries and #entries == 0 and hasMoreEntries then
		v20 = 0
		v28 = false
		v29 = true
	end

	local active = self.props.focusedWidget.active
	local title = self.props.focusedWidget.title
	local id = self.props.focusedWidget.id

	if not active then
		title = nil
	end

	local attributeSet = {}

	local v32 = v18 and not v23
		or fFlagAXMoveAllTabToWidgetOnly and hasProcessedMarketplaceFetcher
		or fFlagAXFixWidgetOnlyTabNoItemsFound and v22
		or active

	if title == "" then
		title = nil
	end

	return withLocalization({
		noItemsFound = "Feature.Catalog.Response.NoItemsFound",
		focusedWidgetTitle = title,
		emptyText = "Feature.DisplayName.ErrorMessage.SomethingWentWrong"
	})(function(p2)
		local nextSelectionRight = self:getNextSelectionRight(name, key2)
		local v35

		if self.props.fromSearch then
			v35 = impressionEnums.MarketplaceSurfaceType.SEARCH
		else
			v35 = impressionEnums.MarketplaceSurfaceType.HOMEPAGE
		end

		local createElement = Roact.createElement
		local v37 = {
			parentRef = self.gridRef,
			pageFilter = 0,
			onRequestImpressionsSignal = 0,
			eventContext = 0,
			eventName = "marketplaceOrganicFELog",
			requestId = 0,
			impressionsTag = 0,
			impressionsSchema = "defaultItem",
			searchUuid = 0,
			surface = 0,
			analyticsMetadata = 0
		}
		local v38

		if fFlagAXUnifiedImpressionsOnThumbnail then
			v38 = fn
		else
			v38 = function(): boolean
				return key == key2
			end
		end

		v37.pageFilter = v38

		v37.onRequestImpressionsSignal = self.requestImpressionsSignal
		v37.eventContext = module35()

		v37.requestId = self.props.widgetRequestId
		v37.impressionsTag = v27

		v37.searchUuid = self.props.searchUuid
		v37.surface = v35
		v37.analyticsMetadata = self.props.analyticsMetadata
		v26 = createElement(module44, v37)

		local createElement2 = Roact.createElement
		local v40 = {
			parentRef = self.gridRef,
			pageFilter = 0,
			onRequestImpressionsSignal = 0,
			filterImpressionFunc = 0,
			onImpressionsDetected = 0,
			collectObjectsFunc = 0
		}
		local v41

		if fFlagAXUnifiedImpressionsOnThumbnail then
			v41 = fn
		else
			v41 = function(): boolean
				return key == key2
			end
		end

		v40.pageFilter = v41

		v40.onRequestImpressionsSignal = self.requestImpressionsSignal
		function v40.filterImpressionFunc(instance)
			local attribute = instance:GetAttribute(widgetConstants.WidgetExposureMetadata.AttributeKey)
			return attribute and not attributeSet[attribute]
		end

		function v40.onImpressionsDetected(items)
			for k, item in items do
				local attribute = item:GetAttribute(widgetConstants.WidgetExposureMetadata.AttributeKey)
				attributeSet[attribute] = true

				IXPService:LogUserLayerExposure(attribute)

				local impressionsReported = self.impressionsReported

				if impressionsReported[item.Name] then
					continue
				end

				self.props.catalogAnalytics.widgetInteractionV2({}, widgetConstants.ActionType.IMPRESSION)
				impressionsReported[item.Name] = true
			end
		end
		function v40.collectObjectsFunc(p3)
			return CollectionService:GetTagged(widgetConstants.WidgetExposureMetadata.TagName)
		end

		local element = createElement2(avatarExperienceScreenSizeImpressionsDetector, v40)

		local frameRef = self.props.frameRef
		local backToTopSignal = self.props.backToTopSignal

		local adaptiveScrolling = self.props.adaptiveScrolling or {}
		local v42

		if self.props.multiTryOnBottomBarRef then
			local value = self.props.multiTryOnBottomBarRef:getValue()
			v42 = not value and 0 or value.AbsoluteSize.Y
		else
			v42 = 0
		end

		local routeName = self.props.navigation.state.routeName
		local namedRef = self.props.namedRefs[routeName .. "TopPanel"]

		local v43 = self.props.selectedSearchCategory

		local v44 = v43.Id == catalogCategories.Avatars:rawValue()

		if self.props.selectedSearchSubcategory then
			v43 = self.props.selectedSearchSubcategory
		end

		local v45 = v43.LooksWidgetContextForOrganicContent ~= nil

		local v46 = {
			fromSearch = self.props.fromSearch,
			catalogAnalytics = self.props.catalogAnalytics,
			axAnalytics = self.props.axAnalytics,
			searchUuid = self.props.searchUuid,
			searchInCatalog = self.props.searchInCatalog,
			hideTopBar = self.props.hideTopBar,
			focusedWidget = self.props.focusedWidget,
			showCloseIcon = self.props.showCloseIcon,
			restorePreviousChildFocus = self.state.restorePreviousChildFocus,
			topPanelRef = self.topPanelRef,
			gridRef = self.gridRef,
			hasEntries = v18,
			backToTopSignal = self.props.backToTopSignal,
			onCategoryOrSubcategoryChange = self.props.onCategoryOrSubcategoryChange,
			onCategoryOrSubcategoryChangeById = self.props.onCategoryOrSubcategoryChangeById,
			onCloseFocusedWidget = self.props.onCloseFocusedWidget,
			hidePillBar = v45
		}

		if not fFlagAXCatalogOffersBannerEnabled then
			v46.updateHeightBinding = self.updateTopPanelHeightBinding
		end

		local v47

		if fFlagAXHideMenuOnScroll and self.props.visibilityRatioBinding then
			v47 = Roact.joinBindings({
				visibility = self.props.visibilityRatioBinding,
				height = self.topPanelHeightBinding
			}):map(function(p3)
				local v48 = math.floor((1 - p3.visibility) * -p3.height)
				return UDim2.fromOffset(0, v48)
			end)
		end

		local v48

		if fFlagAXHideMenuOnScroll and self.props.visibilityRatioBinding then
			v48 = Roact.joinBindings({
				visibility = self.props.visibilityRatioBinding,
				height = self.topPanelHeightBinding
			}):map(function(p3)
				local v49 = p3.height * p3.visibility
				return UDim2.new(1, 0, 1, -v49)
			end)
		end

		local v49

		if fFlagAXHideMenuOnScroll and self.props.visibilityRatioBinding then
			v49 = Roact.joinBindings({
				visibility = self.props.visibilityRatioBinding,
				height = self.topPanelHeightBinding
			}):map(function(p3)
				local v50 = p3.height * p3.visibility
				return UDim2.fromOffset(0, v50)
			end)
		end

		local createElement3 = Roact.createElement
		local frame = focusable.Frame
		local frameRefsByRef = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ClipsDescendants = false,
			LayoutOrder = self.props.layoutOrder,
			[Roact.Ref] = frameRef,
			defaultChild = self.topPanelRef,
			NextSelectionUp = self.props.NextSelectionUp,
			restorePreviousChildFocus = self.state.restorePreviousChildFocus
		}

		local v51 = if backToTopSignal then Roact.createElement(module24, {
			signal = backToTopSignal,
			callback = self.scrollBackToTop
		}) else nil

		local createElement4 = Roact.createElement
		local focusNavigationBindingsRefsByRef = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ClipsDescendants = false,
			[Roact.Ref] = self.props.focusNavigationBindingsRef
		}
		local v54

		if fFlagAXCatalogOffersBannerEnabled then
			local createElement5 = Roact.createElement
			local frame2 = focusable.Frame
			local v55 = {
				["BackgroundTransparency"] = nil,
				["BackgroundTransparency"] = nil,
				BackgroundTransparency = theme.BackgroundMuted.Transparency,
				BackgroundColor3 = theme.BackgroundMuted.Color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
				ref = namedRef
			}

			if not fFlagAXHideMenuOnScroll then
				v47 = nil
			end

			v55.Position = v47
			v55[Roact.Change.AbsoluteSize] = function(p3)
				self.updateTopPanelHeightBinding(p3.AbsoluteSize.Y)
			end
			local v56 = {
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				OffersBanner = 0,
				Navigation = 0
			}

			local v57 = if fFlagAXCatalogOffersBannerEnabled and self.props.hideTopBar ~= true then Roact.createElement("Frame", {
				BackgroundTransparency = theme.BackgroundMuted.Transparency,
				BackgroundColor3 = theme.BackgroundMuted.Color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 0
			}, { OffersBanner = React.createElement(module31) }) else nil
			v56.OffersBanner = v57

			v56.Navigation = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}, {
				Content = Roact.createElement(module32, v46)
			})
			v54 = createElement5(frame2, v55, v56)
		else
			local createElement5 = Roact.createElement
			local frame2 = focusable.Frame
			local v55 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
				ref = namedRef,
				Position = 0
			}

			if not fFlagAXHideMenuOnScroll then
				v47 = nil
			end

			v55.Position = v47
			v54 = createElement5(frame2, v55, Roact.createElement(module32, v46))
		end

		local createElement5 = Roact.createElement

		local v56 = {
			ref = self.props.defaultFocusRef,
			Size = fFlagAXHideMenuOnScroll and v48 or self.topPanelHeightBinding:map(function(p3)
				return UDim2.new(1, 0, 1, -p3)
			end),
			Position = fFlagAXHideMenuOnScroll and v49 or self.topPanelHeightBinding:map(function(p3)
				return UDim2.fromOffset(0, p3)
			end),
			BackgroundTransparency = 1,
			ClipsDescendants = fFlagAXMigrateAllTabToSduiDev and fFlagAXCategoryMenuVisualFixes and true or nil
		}
		local children2

		if fFlagAXMigrateAllTabToSduiDev and self.props.showSduiResults then
			children2 = { SduiResults = 0 }
			local createElement6 = React.createElement
			local v58 = {
				context = self.props.context or "",
				Size = UDim2.new(1, 0, 1, 0),
				ref = self.gridRef,
				onScroll = self.onItemsListScroll,
				requestImpressionsSignal = self.requestImpressionsSignal,
				scrollPositionRef = 0,
				scrollRestoreRef = 0,
				scrollPerformanceIntervalName = 0
			}

			local v59 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then self.sduiFeedScrollPositionRef else nil
			v58.scrollPositionRef = v59

			local v60 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then self.sduiFeedScrollRestoreRefs[self.props.searchUuid] else nil
			v58.scrollRestoreRef = v60

			local v61 = if fFlagAXScrollTelemetryIntegration2 then self.props.scrollPerformanceIntervalName else nil
			v58.scrollPerformanceIntervalName = v61
			children2.SduiResults = createElement6(catalogSduiFeedEntryPoint, v58)
		elseif self.state.showFailedState then
			children2 = { EmptyState = 0 }
			children2.EmptyState = Roact.createElement(emptyState, {
				onActivated = self.props.onRetry,
				text = p2.emptyText,
				[Roact.Ref] = self.emptyStateRef
			})
		else
			children2 = { WidgetList = 0, NoItemsFound = 0, AvatarsTabError = 0 }
			local createElement6 = Roact.createElement
			local widgetList = module26.WidgetList
			local v57 = {
				entries = entries,
				fromSearch = self.props.fromSearch,
				bottomBarHeight = v42,
				showingEntries = v21,
				searchUuid = self.props.searchUuid,
				loadMore = v23 and self.loadMore or nil,
				hasMoreRows = v23,
				shouldCreateEndOfScrollElement = v32,
				itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
				gridRef = self.gridRef,
				flatListRef = self.widgetFlatListRef,
				onScroll = self.onItemsListScroll,
				focusedWidget = if active then id else nil,
				onWidgetFocusAcquired = self.setFocusedWidget,
				onWidgetFocusReleased = self.clearFocusedWidget,
				requestImpressionsSignal = self.requestImpressionsSignal,
				onNumItemsPerRowChanged = self.onNumItemsPerRowChanged,
				NextSelectionRight = nextSelectionRight,
				NextSelectionUp = self.topPanelRef,
				restorePreviousChildFocus = self.state.restorePreviousChildFocus,
				onFocusGained = 0,
				numItemsExpected = 0,
				scrollingEnabled = 0,
				listHeaderComponent = 0,
				pillBarVisible = 0,
				scrollPerformanceIntervalName = 0
			}
			local v59 = if not self.state.restorePreviousChildFocus then self.onFocusGained or nil else nil
			v57.onFocusGained = v59
			v57.numItemsExpected = v20
			local v60

			if adaptiveScrolling.scrollingEnabledBinding then
				v60 = adaptiveScrolling.scrollingEnabledBinding:map(function(p3)
					return p3
				end)
			else
				v60 = fFlagAXAdaptiveScrollingFixForward and true or adaptiveScrolling.scrollingEnabled
			end

			v57.scrollingEnabled = v60

			v57.listHeaderComponent = Roact.createElement(module33)
			v57.pillBarVisible = not v45

			local v61 = if fFlagAXScrollTelemetryIntegration2 then self.props.scrollPerformanceIntervalName else nil
			v57.scrollPerformanceIntervalName = v61
			children2.WidgetList = createElement6(widgetList, v57)

			children2.NoItemsFound = v28 and Roact.createElement(fitTextLabel, {
				width = UDim.new(1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, data.Tokens.Size.Size_800),
				Text = p2.noItemsFound,
				TextSize = v25,
				TextColor3 = color,
				TextTransparency = transparency,
				Font = font2
			})

			local v62 = v29

			if v62 then
				v62 = Roact.createElement(
					"Frame",
					{
						LayoutOrder = self.props.layoutOrder,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1
					},
					{
						EmptyState = Roact.createElement(emptyState, {
							onActivated = self.loadMore,
							text = p2.emptyText,
							[Roact.Ref] = self.emptyStateRef
						})
					}
				)
			end

			children2.AvatarsTabError = v62
		end

		local children = {
			BackToTopSignal = v51,
			ScrollPanel = createElement4("Frame", focusNavigationBindingsRefsByRef, {
				TopPanel = v54,
				ListFrame = createElement5("Frame", v56, children2)
			}),
			ImpressionsReporter = v26,
			WidgetImpressionsReporter = element,
			UnifiedImpressionsReporter = 0
		}

		local createElement6 = Roact.createElement
		local v58 = {
			parentRef = self.gridRef,
			pageFilter = 0,
			requestImpressionsSignal = 0,
			extensions = 0
		}
		local v59

		if fFlagAXUnifiedImpressionsOnThumbnail then
			v59 = fn
		else
			v59 = function(): boolean
				return key == key2
			end
		end

		v58.pageFilter = v59

		v58.requestImpressionsSignal = self.requestImpressionsSignal
		v58.extensions = self.props.tagBasedImpressionsDetectorExtensions
		children.UnifiedImpressionsReporter = createElement6(tagBasedImpressionsDetector, v58)
		return createElement3(frame, frameRefsByRef, children)
	end)
end

function extended:render()
	return withStyle(function(p2)
		return self:renderResultsList(p2)
	end)
end

function extended.updateItems(object, p2)
	local searchInCatalog = object.props.searchInCatalog
	local items = searchInCatalog and searchInCatalog.items or nil

	local v18 = if fFlagAXMoveAllTabToWidgetOnly then object.props.shouldPageUseWidgetOnly else false
	local hasProcessedMarketplaceFetcher

	if fFlagAXMoveAllTabToWidgetOnly then
		hasProcessedMarketplaceFetcher = v18 and object.props.hasProcessedMarketplaceFetcher
	end

	local v19 = fFlagAXMoveAllTabToWidgetOnly and hasProcessedMarketplaceFetcher and {} or items

	if object.props.externalNavigationRequestParams then
		if module16.newValidEquipDeepLinkExists(object.props.externalNavigationRequestParams) then
			local itemIdAndItemType, v20 = module16.parseItemIdAndItemType(object.props.externalNavigationRequestParams)
			local v21 = itemData(object.props.itemInfos, itemIdAndItemType, v20)

			if v21 then
				local itemSubType = module16.parseItemSubType(v20, v21)

				if fFlagAXMISEnableMultiShoppingUnifiedEvents then
					local v22 = nil

					if v20 == "Asset" then
						v22 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
					elseif v20 == "Bundle" then
						v22 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
					end

					local v24 = {
						action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
						cartId = cartIdService.getCartId(),
						itemId = itemIdAndItemType,
						itemType = v22,
						assetType = 0,
						bundleType = 0,
						organicItemPrice = 0,
						surface = 0
					}

					local v25 = if v20 == "Asset" then itemSubType else nil
					v24.assetType = v25
					local v26 = if v20 ~= "Asset" then itemSubType else nil
					v24.bundleType = v26
					v24.organicItemPrice = v21.priceInRobux

					local v27 = if fFlagAXUnifiedEventStrictPayloads then AvatarExperienceNavigation.Enums.UnifiedLoggingSurface.UNDEFINED_SURFACE else nil
					v24.surface = v27
					sendUnifiedEventLog(v24)
				end

				object.props.equipCatalogDeepLinkItem(
					object.props.networking,
					object.props.catalogAnalytics,
					v20,
					itemSubType,
					itemIdAndItemType,
					true,
					object.props.avatarRoute,
					object.props.navigation,
					object.props.widgetAnalyticsInfo
				)
			elseif not object.props.externalNavigationRequestParams.wasItemEquipped then
				object.props.fetchItemData(
					object.props.networking,
					object.props.catalogAnalytics,
					itemIdAndItemType,
					v20
				):catch(function()
					object.props.handleDeepLinkEquipError(itemIdAndItemType, v20)
					module16.removeDeepLinkEntries(v19)
				end)
			end
		end

		if object.props.externalNavigationRequestParams.wasItemEquipped then
			local tryOnItems = object.props.tryOnItems
			local v20 = if fFlagAXFixCatalogRefreshRendering and object.props.categoryInfo then object.props.categoryInfo else nil

			local categoryInfo = object.props.searchParameters
				and object.props.searchParameters.categoryInfo
				or v20
				or {}

			module16.addEquippedItemToCatalogEntries(
				object.props.externalNavigationRequestParams,
				tryOnItems,
				categoryInfo,
				v19
			)
		end
	end

	if not v19 then
		object:setState({ entries = Roact.None })

		return
	end

	local tryOnItems = object.props.tryOnItems

	if
		p2
		and not (Cryo.isEmpty(tryOnItems) or fFlagAXMoveAllTabToWidgetOnly and hasProcessedMarketplaceFetcher)
		and object.props.tryOnLookId == nil
	then
		local categoryInfo = object.props.searchParameters and object.props.searchParameters.categoryInfo
			or {}
		local joined = {}
		local total = 0

		if categoryInfo.AssetTypeIdStrings then
			for k, assetTypeIdString in categoryInfo.AssetTypeIdStrings do
				joined = Cryo.Dictionary.join(joined, {
					[assetTypeIdString] = module14.ItemType.Asset
				})
			end

			total += #categoryInfo.AssetTypeIdStrings
		end

		if categoryInfo.BundleTypes then
			for k, bundleType in categoryInfo.BundleTypes do
				joined = Cryo.Dictionary.join(joined, {
					[bundleType] = module14.ItemType.Bundle
				})
			end

			total += #categoryInfo.BundleTypes
		end

		local v20 = table.create(#v19)

		if total > 0 then
			for k, tryOnItem in tryOnItems do
				if
					tryOnItem.lookId
					or not tryOnItem.itemSubType
					or joined[tryOnItem.itemSubType] ~= tryOnItem.itemType
				then
					continue
				end

				table.insert(v20, {
					id = tostring(tryOnItem.itemId),
					type = tostring(tryOnItem.itemType),
					encryptedAdTrackingData = nil
				})
			end
		end

		for k, v21 in v19 do
			if not tryOnItems[getTryOnItemReducerKey(v21.id, v21.type)] then
				table.insert(v20, v21)
			end
		end

		object:setState({ entries = v20 })
	elseif not Cryo.List.equals(object.state.entries, v19) then
		object:setState({ entries = v19 })
	end
end

function extended:registerSduiFocusedSortHandler()
	if self.sduiFocusedSortOwnerId then
		return
	end

	local routeName = self.props.navigation.state.routeName
	self.sduiFocusedSortOwnerId = `ResultsList:{tostring(self)}`
	marketplaceCatalogSduiSelectionBridge.registerFocusedSortHandler(
		self.sduiFocusedSortOwnerId,
		function(data)
			local sduiFocusedSortContext = resolveSduiFocusedSortContext({
				routeName = routeName,
				selectedCategoryId = self.props.selectedCategoryId,
				selectedSubcategoryId = self.props.selectedSubcategoryId,
				getContextForWidgetsById = module29.getContextForWidgetsById,
				sortId = data and data.sortId
			})

			if not (sduiFocusedSortContext and self.props.dispatchApplySduiFocusedSort(
				data,
				sduiFocusedSortContext,
				self.props.networking
			)) then
				return
			end

			if fFlagAXSduiFeedMaintainScrollOnSeeAll then
				self.sduiFeedScrollRestoreRefs[self.props.searchUuid] = {
					current = self.sduiFeedScrollPositionRef.current
				}
			end

			self.setFocusedWidget({
				id = data.sortId,
				template = {
					localizedTitle = data.title,
					localizedDescription = data.description,
					localizedTooltip = data.tooltipText
				}
			})

			self.sduiFocusedSortContext = sduiFocusedSortContext
		end
	)
end

function extended:unregisterSduiFocusedSortHandler()
	if self.sduiFocusedSortOwnerId then
		marketplaceCatalogSduiSelectionBridge.unregisterFocusedSortHandler(self.sduiFocusedSortOwnerId)
		self.sduiFocusedSortOwnerId = nil
	end

	if self.sduiFocusedSortContext then
		self.props.dispatchClearSduiFocusedSort(self.sduiFocusedSortContext)
		self.sduiFocusedSortContext = nil
	end
end

function extended:didMount()
	self:updateItems(true)

	if fFlagAXMigrateAllTabToSduiDev and self.props.navigation.state.routeName == avatarScreen.Catalog then
		self:registerSduiFocusedSortHandler()
	end
end

function extended:willUnmount()
	if fFlagAXUnifiedImpressionsOnThumbnail then
		seenImpressionsStore.clearCategory(seenImpressionsStore.Category.UnifiedImpressions)
	end

	if fFlagAXMigrateAllTabToSduiDev then
		self:unregisterSduiFocusedSortHandler()
	end
end

function extended:didUpdate(data, p2)
	local v18 = self.props.searchUuid ~= data.searchUuid

	if self.props.fromSearch then
		v18 = v18 or data.categoryInfo ~= self.props.categoryInfo or not self.props.searchInCatalog
	end

	if v18 and self.state.restorePreviousChildFocus ~= false then
		self:setState({ restorePreviousChildFocus = false })
	end

	if v18 or self.state.numItemsPerRow ~= p2.numItemsPerRow then
		self.requestImpressionsSignal:fire()
	end

	local v19 = self.props.dataStatus == module12.Done and data.dataStatus ~= module12.Done

	local hasProcessedMarketplaceFetcher = if fFlagAXMoveAllTabToWidgetOnly then self.props.hasProcessedMarketplaceFetcher else nil

	local v20 = if fFlagAXMoveAllTabToWidgetOnly then self.props.shouldPageUseWidgetOnly else false
	local v21 = if fFlagAXMoveAllTabToWidgetOnly then v20 and hasProcessedMarketplaceFetcher else nil
	local searchInCatalog = self.props.searchInCatalog
	local items = searchInCatalog and searchInCatalog.items or nil

	local v22 = fFlagAXMoveAllTabToWidgetOnly and v21 and not items and {} or items

	if fFlagAXFixCatalogRefreshRendering then
		local v24

		if self.props.externalNavigationRequestParams and data.externalNavigationRequestParams then
			v24 = self.props.externalNavigationRequestParams.wasItemEquipped ~= data.externalNavigationRequestParams.wasItemEquipped
		else
			v24 = self.props.externalNavigationRequestParams ~= data.externalNavigationRequestParams
				or false
		end

		local v25 = self.props.itemInfos ~= data.itemInfos

		if fFlagAXMoveAllTabToWidgetOnly then
			local v26 = not Cryo.List.equals(self.state.entries, v22)
			local v27 = data.hasProcessedMarketplaceFetcher ~= self.props.hasProcessedMarketplaceFetcher

			if v24 or v25 or (v18 or v19) and v26 or v27 and v26 then
				self:updateItems(v18)
			end
		elseif v24 or v25 or (v18 or v19) and not Cryo.List.equals(self.state.entries, v22) then
			self:updateItems(v18)
		end
	else
		self:updateItems(v18)
	end

	if
		self.props.dataStatus == module12.Done
		and data.dataStatus == module12.Fetching
		and self.retryLoadMore
	then
		self.retryLoadMore = false
		self.loadMore()
	end

	if
		self.shouldScrollBackToTopOfList({
			searchChanged = v18,
			oldSortsAndFilter = data.sortAndFilters,
			newSortsAndFilter = self.props.sortAndFilters
		})
		and self.widgetFlatListRef
		and self.widgetFlatListRef.current
	then
		self.widgetFlatListRef.current:scrollToOffset({ offset = 0, animated = false })
	end

	local v23 = self.props.dataStatus == module12.Failed
	local entries = self.state.entries
	local v24 = entries and #entries ~= 0
	local v25 = v23 and not v24

	if
		(fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev)
		and self.props.isFetchingMarketplaceError
	then
		v25 = self.props.isFetchingMarketplaceError
	elseif fFlagAXMoveAllTabToWidgetOnly and self.props.shouldPageUseWidgetOnly then
		v25 = self.props.isFetchingMarketplaceError
	end

	if v25 ~= p2.showFailedState and v25 ~= self.state.showFailedState then
		self:setState({ showFailedState = v25 })

		if v25 then
			local catalogAnalytics = self.props.catalogAnalytics

			if self.props.navigation.state.routeName == avatarScreen.CatalogSearch then
				catalogAnalytics.sendAXCounter(module43.Counter.Errors.NoInternetConnectionErrorSearchView)
			else
				catalogAnalytics.sendAXCounter(module43.Counter.Errors.NoInternetConnectionErrorCatalogView)
			end
		end
	end
end

local function mapStateToProps(data, data2)
	local searchUuid = data2.searchUuid
	local categoryInfo = data2.categoryInfo

	local searchKey = module15.getSearchKey(data, searchUuid)

	local v18 = false
	local v19 = nil
	local fromSearch = data2.fromSearch

	if searchUuid and fromSearch then
		local searchesParameter = data.SearchesParameters[searchUuid]
		local queryStringForSearchWidgets = module29.getQueryStringForSearchWidgets(searchesParameter)
		local v20 = data.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[queryStringForSearchWidgets]

		if v20 then
			local details = v20.Details
			local v21 = typeof(details) == "table" and next(details) ~= nil

			v18 = if v21 then Cryo.isEmpty(categoryInfo) or categoryInfo.ShowWidgets or false else false
		end

		local v21

		if fFlagAXMoveAllTabToWidgetOnly then
			local debouncedScreenSize = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)

			v21 = module29.getFetchWidgetInfoFetchKey(queryStringForSearchWidgets, nil, debouncedScreenSize)
		else
			v21 = module29.getFetchWidgetInfoFetchKey(queryStringForSearchWidgets)
		end

		v19 = performFetch.GetStatus(data, v21)
	elseif fFlagAXFixWidgetOnlyTabNoItemsFound and categoryInfo and data2.shouldPageUseWidgetOnly then
		local widgetContext = categoryInfo.WidgetContext

		if widgetContext then
			local v20 = data.AvatarExperience.Common.Widgets.ContextWidgetInfo[widgetContext]

			if v20 then
				v18 = typeof(v20.Details) == "table" and next(v20.Details) ~= nil
			end
		end
	end

	local params = data.AvatarExperience.ExternalNavigationRequest.params or {}

	local v20 = {
		fullView = module27(data, avatarScreen.Catalog),
		searchParameters = data.SearchesParameters[data2.searchUuid],
		sortAndFilters = data.AvatarExperience.Catalog.SortAndFilters,
		filterCount = 0,
		searchInCatalog = 0,
		dataStatus = 0,
		tryOnItems = 0,
		tryOnLookId = 0,
		focusedWidget = 0,
		hideTopBar = 0,
		widgetRequestId = 0,
		widgetDataStatus = 0,
		hasWidgets = 0,
		externalNavigationRequestParams = 0,
		analyticsMetadata = 0
	}
	local v21 = if fFlagAXMoveAllTabToWidgetOnly then module28(data) else nil
	v20.filterCount = v21
	v20.searchInCatalog = data.Search.SearchesInCatalog[data2.searchUuid]
	v20.dataStatus = performFetch.GetStatus(data, searchKey)
	v20.tryOnItems = data.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	v20.tryOnLookId = data.AvatarExperience.AvatarScene.OutfitTryOn.LookId
	v20.focusedWidget = data.AvatarExperience.Catalog.ResultsList[data2.searchUuid]
		and data.AvatarExperience.Catalog.ResultsList[data2.searchUuid].focusedWidget
		or {}
	local v22 = if data.AvatarExperience.Catalog.ResultsList[data2.searchUuid] then data.AvatarExperience.Catalog.ResultsList[data2.searchUuid].hideTopBar or false else false
	v20.hideTopBar = v22

	v20.widgetRequestId = data.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
	v20.widgetDataStatus = v19
	v20.hasWidgets = v18
	v20.externalNavigationRequestParams = params
	v20.analyticsMetadata = data.AvatarExperience.AnalyticsMetadata
	return v20
end

local function mapDispatchToProps(callback)
	return {
		dispatchLoadMore = function(p2, p3, p4, p5, p6)
			return callback(GetGameName(module20(
				{ searchKeyword = p3, searchUuid = p4, categoryInfo = p5 },
				p6
			)))
		end,
		dispatchSetResultsListFocusedWidget = function(p2, p3, p4)
			return callback(module36(p2, p3, p4))
		end,
		dispatchClearResultsListFocusedWidget = function(p2)
			return callback(module37(p2))
		end,
		dispatchCatalogTilesLatencyStartTracker = function(p2)
			return callback(module10.StartTracking(p2))
		end,
		fetchItemData = function(p2, p3, p4, p5)
			return callback(module21(p2, p3, p4, p5))
		end,
		handleDeepLinkEquipError = function(p2, p3)
			callback(module2({
				toastMessage = "Feature.Avatar.Message.DeepLinkEquipFailed"
			}))

			callback(module42({
				itemId = p2,
				itemType = p3,
				wasItemEquipped = false,
				fetchItemFailed = true
			}))

			callback(clearTryOns())
		end,
		equipCatalogDeepLinkItem = function(p2, p3, p4, p5, p6, p7, p8, p9, p10)
			callback(module22(p2, p3, p4, p5, p6, p7, p8, p9, p10, true))

			callback(module42({
				itemId = p6,
				itemType = p4,
				wasItemEquipped = true,
				fetchItemFailed = false
			}))
		end
	}
end

local v18 = module25((module13((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)))))

local v19 = withAdaptiveScrolling((withNavigation((roactServices.connect({
	axAnalytics = avatarExperienceAnalyticsService,
	catalogAnalytics = module18,
	networking = module
})(v18)))))

local function selectItemInfos(p2)
	return {
		AssetInfos = p2.AvatarExperience.Common.AssetInfos,
		BundleInfos = p2.AvatarExperience.Common.BundleInfos
	}
end

local function ResultsListWrapper(props)
	local clone = table.clone(props)

	local v20 = useDispatch()
	local v21 = useFocusGuiObject()
	local v22 = useSelector(function(p2)
		return p2.AvatarExperience.Catalog.ResultsList
	end)
	local focusedWidget = v22[props.searchUuid] and v22[props.searchUuid].focusedWidget
	local v23 = if focusedWidget then focusedWidget.active else false

	clone.focusNavigationBindingsRef = module45({
		onNavigateBack = React.useCallback(function(p2)
			p2.cancelled = true

			if v23 then
				v20(module37(props.searchUuid))

				if type(props.onCloseFocusedWidget) == "function" then
					props.onCloseFocusedWidget()
				end
			elseif v21 and props.NextSelectionUp and props.NextSelectionUp.current then
				v21(props.NextSelectionUp.current)
			end
		end, {
			v21,
			props.NextSelectionUp,
			v23,
			props.searchUuid,
			v20,
			props.onCloseFocusedWidget
		})
	}, props.frameRef)

	if fFlagAXItemDetailsIxpExposure then
		local v24 = useUnifiedEventImpressionsReporter()
		clone.tagBasedImpressionsDetectorExtensions = React.useMemo(function()
			if fFlagAXBackgroundGenerationAnalytics then
				return { v24, reportVisibleUpsellImpression }
			end

			return { v24 }
		end, { v24 })
	end

	local catalogSelectionStore = module9.getCatalogSelectionStore()
	local v24 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v25 = useSignalState(catalogSelectionStore.selectedSubcategoryId)
	clone.selectedCategoryId = v24
	clone.selectedSubcategoryId = v25

	local catalogSearchSelectionStore = module9.getCatalogSearchSelectionStore()
	local v26 = useSignalState(catalogSearchSelectionStore.selectedCategoryId)
	local v27 = useSignalState(catalogSearchSelectionStore.selectedSubcategoryId)
	clone.selectedSearchCategoryId = v26
	clone.selectedSearchSubcategoryId = v27

	local v28 = useSignalState(catalogSelectionStore.selectedCategory)
	clone.selectedCategory = v28

	local v29 = useSignalState(catalogSearchSelectionStore.selectedCategory)
	clone.selectedSearchCategory = v29

	clone.selectedSearchSubcategory = useSignalState(catalogSearchSelectionStore.selectedSubcategory)

	if props.fromSearch then
		v28 = v29
	end

	clone.categoryInfo = v28

	if fFlagAXHideMenuOnScroll then
		local v30 = useAnimatedVisibility()

		local v31 = if v30 then SignalsReact.useSignalBinding(v30.animatedMenusStore.getVisibilityRatio) else React.createBinding(1)

		clone.visibilityRatioBinding = v31
	end

	if fFlagAXCatalogCategoriesSDUI or fFlagAXMoveAllTabToWidgetOnly or fFlagAXMigrateAllTabToSduiDev then
		local fetchMarketplaceStore = module34.getFetchMarketplaceStore(false)
		local v30 = useSignalState(fetchMarketplaceStore.getFetchingMarketplaceError)
		local v31

		if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
			v31 = useSignalState(fetchMarketplaceStore.getCatalogCategoriesError)
		end

		clone.isFetchingMarketplaceError = v30

		if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
			clone.isFetchingMarketplaceError = v30 or v31
		end

		if fFlagAXMoveAllTabToWidgetOnly then
			clone.hasProcessedMarketplaceFetcher = useSignalState(fetchMarketplaceStore.getFetchingMarketplaceProcessed)

			local v32 = useSelector(React.useCallback(function(p2)
				return p2.SearchesParameters[props.searchUuid]
			end, { props.searchUuid }), getUseSelectorDeepEquals())
			local v33 = useSelector(module28)

			clone.shouldPageUseWidgetOnly = getShouldPageUseWidgetOnlyFetcher(
				clone.categoryInfo,
				v33,
				v32 and v32.searchKeyword
			)
		end
	end

	clone.itemInfos = useSelector(selectItemInfos, tutils.shallowEqual)

	if fFlagAXMigrateAllTabToSduiDev then
		local v30 = module46() and not v23

		local widgetContext = v28 and v28.WidgetContext or ""

		clone.showSduiResults = v30
		clone.context = widgetContext

		local v31 = useStore()
		local v32 = React.useCallback(function()
			return v31:getState().AvatarExperience.Common.Widgets.HydratedWidgetData
		end, { v31 })
		local v33

		if fFlagAXSduiSeeAllPageRequestId then
			v33 = React.useCallback(function()
				local catalogPageRequestIdStore = getCatalogPageRequestIdStore(false)
				local catalogPageIdentifier = getCatalogPageIdentifier(widgetContext)
				return catalogPageRequestIdStore.getPageRequestIdMap(false)[catalogPageIdentifier]
			end, { widgetContext })
		end

		local v35 = {
			SetWidgetInfo = module38,
			SetHydratedWidgetData = module40,
			CatalogWebApi = GetExperienceSourceLanguage,
			getHydratedWidgetData = v32,
			getPageRequestId = nil
		}

		if not fFlagAXSduiSeeAllPageRequestId then
			v33 = nil
		end

		v35.getPageRequestId = v33
		clone.dispatchApplySduiFocusedSort = useApplySduiFocusedSort(v35)

		clone.dispatchClearSduiFocusedSort = useClearSduiFocusedSort({
			ClearWidgetInfo = module39
		})
	end

	if fFlagAXSharedImpressionRescan then
		clone.requestImpressionsSignal = useOnRequestImpressionsSignal()
	end

	if fFlagSduiMarketplaceCatalogSortSupport then
		return React.createElement(v5, nil, React.createElement(v19, clone))
	end

	return React.createElement(v19, clone)
end

return ResultsListWrapper
