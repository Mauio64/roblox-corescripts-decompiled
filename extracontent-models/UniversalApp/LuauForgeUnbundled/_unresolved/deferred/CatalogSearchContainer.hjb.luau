local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local focusable = RoactGamepad.Focusable
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module = require("@luauforge/bundled/eie")
local useNavBarSize = require("@luauforge/bundled/dKz").useNavBarSize

local module2 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior
local useFocusOnMount = module2.useFocusOnMount
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module2.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/bundled/ecr")

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local deviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module7 = require("@luauforge/bundled/gLF")
local ttiPerformanceManager = module7.TTIPerformanceManager
local organicTTIMilestoneManager = module7.OrganicTTIMilestoneManager

local module8 = require("@luauforge/bundled/fxg")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local module10 = require("@luauforge/bundled/fvR")
local module11 = require("@luauforge/bundled/fAj")
local module12 = require("@luauforge/bundled/fwU")
local module13 = require("@luauforge/bundled/dWq")
local module14 = require("@luauforge/bundled/fIl")
local module15 = require("@luauforge/deferred/gRU")

local module16 = require("@luauforge/bundled/fwS")
local module17 = require("@luauforge/bundled/fwR")

local module18 = require("@luauforge/bundled/fwM")

local UIBlox = require(CorePackages.Packages.UIBlox)

local horizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dKT")
local module20 = require("@luauforge/bundled/dXh")
local module21 = require("@luauforge/bundled/fAf")
local module22 = require("@luauforge/bundled/gZE")
local module23 = require("@luauforge/bundled/fCe")
local module24 = require("@luauforge/deferred/gLn")
local module25 = require("@luauforge/deferred/gLl")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module26 = require("@luauforge/deferred/gTt")
local module27 = require("@luauforge/deferred/gJK")
local module28 = require("@luauforge/bundled/gSI")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local module29 = require("@luauforge/bundled/dKU")
local setItemDetailsPeekViewState = module29.Actions.SetItemDetailsPeekViewState
local module30 = require("@luauforge/deferred/fCu")
local module31 = require("@luauforge/deferred/hgS")
local module32 = require("@luauforge/bundled/gSD")
local fullView = AvatarExperienceCommon.Enums.FullView
local module33 = require("@luauforge/deferred/gQN")
local module34 = require("@luauforge/deferred/gQQ")

local module35 = require("@luauforge/bundled/fDf")
local module36 = require("@luauforge/bundled/dPU")
local module37 = require("@luauforge/deferred/hfL")
local module38 = require("@luauforge/bundled/dVl")
local module39 = require("@luauforge/bundled/hae")
local module40 = require("@luauforge/bundled/dVS")
local module41 = require("@luauforge/deferred/gQx")
local setTryOnManagerPeekViewState = module29.Actions.SetTryOnManagerPeekViewState
local module42 = require("@luauforge/bundled/gZZ")
local module43 = require("@luauforge/bundled/gZR")
local useShouldFetchCartPricingForPurchasePrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Hooks.useShouldFetchCartPricingForPurchasePrompt

local module44 = require("@luauforge/bundled/fyM")
local module45 = require("@luauforge/bundled/dRs")
local fFlagAXEnableManualSaving = AvatarExperienceFlags.FFlagAXEnableManualSaving

local fFlagAXFixEmptyCatalogSearchChrome = AvatarExperienceFlags.FFlagAXFixEmptyCatalogSearchChrome

local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2

local fFlagAXExpandPeekViewOnFirstScroll = AvatarExperienceFlags.FFlagAXExpandPeekViewOnFirstScroll
local fFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local fFlagAXFixSearchBarPortraitBackground = AvatarExperienceFlags.FFlagAXFixSearchBarPortraitBackground
local fFlagAXMeTabTopScrim = AvatarExperienceFlags.FFlagAXMeTabTopScrim
local module46 = require("@luauforge/bundled/dXj")
local fFlagAXFixCatalogSearchBarSafeArea = AvatarExperienceFlags.FFlagAXFixCatalogSearchBarSafeArea
local fFlagAXCatalogSearchKeepFilters = AvatarExperienceFlags.FFlagAXCatalogSearchKeepFilters
local fFlagAXUnifiedAutocompleteExposureLogging = AvatarExperienceFlags.FFlagAXUnifiedAutocompleteExposureLogging

local defineFastFlag = game:DefineFastFlag("AXFixCatalogSearchBarForDeviceSafeInsets", false)
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dXA").shouldUseDeviceSafeInsets

local module47 = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local recentSearchTermsAppStorage = module8.Utils.RecentSearchTermsAppStorage
local searchViewExposureLogger = module8.Components.SearchViewExposureLogger

local v5 = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.ToggleTryOn
}

local function fn(p2)
	return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function useCatalogSearchFocusNavigationBindings(p2, p3, p4)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = p3 and {
				handler = InputHandlers.onRelease(p3)
			} or nil,
			[focusNavigationEventNameEnum.ToggleTryOn] = p4 and {
				handler = InputHandlers.onRelease(p4)
			} or nil
		}
	end, { p3, p4 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local extended = Roact.PureComponent:extend("CatalogSearch")

local strictInterface = t.strictInterface
local v6 = {}
v6.searchUuid = t.string
v6.searchParameters = t.table
v6.isVisible = t.optional(t.boolean)

v6.fullView = t.optional(t.userdata)
v6.topBarHeight = t.number
v6.statusBarHeight = t.optional(t.number)
v6.dataStatus = t.string
v6.hasEntries = t.boolean
v6.itemDetailsExpanded = t.optional(t.boolean)
v6.isPortrait = t.boolean
v6.tryOnManagerPeekViewState = t.optional(t.valueOf(peekViewState))
v6.categoryInfo = t.optional(t.table)
local v7 = if fFlagAXCatalogSearchKeepFilters then t.optional(t.table) else nil
v6.externalNavigationRequest = v7

v6.dispatchSearch = t.callback
v6.dispatchRemoveSearch = t.callback
v6.setSearchType = t.callback
v6.setSearchParameters = t.callback
v6.setSortAndFilters = t.callback
v6.openItemPrompt = t.callback
v6.setItemDetailsPeekViewState = t.callback
v6.setFullView = t.callback
v6.navigateIntoQuickMenu = t.callback
v6.resetSortAndFilters = t.callback
v6.setTryOnManagerPeekViewState = t.callback
v6.fetchWidgetInfo = t.callback
v6.dispatchCatalogTilesLatencyStartTracker = t.callback
v6.dispatchSearchWithParameters = t.callback

v6.pageObjectManager = t.optional(t.table)
v6.namedRefs = t.table

v6.navigation = t.table

v6.avatarRoute = avatarRoute.Interface

v6.avatarExperienceAnalytics = t.table
v6.networking = t.callback
v6.eventIngest = t.table

v6.overlayClosedCallback = t.callback
v6.localized = t.table
v6.designTokens = t.table
v6.focusNavigationRef = t.table
v6.navBarSize = t.number
v6.defaultFocusRef = t.optional(t.callback)
extended.validateProps = strictInterface(v6)

function extended:init()
	local binding, v8 = Roact.createBinding(0)
	self.pillBarScrollOffset = binding
	self.updatePillBarScrollOffset = v8
	self.searchBarRef = Roact.createRef()
	self.sceneUIContainerRef = Roact.createRef()
	self.resultsListRef = self.props.namedRefs[avatarScreen.CatalogSearch .. module24.ItemsList]
	self.refinementButtonsRef = Roact.createRef()
	self.multiTryOnBottomBarRef = Roact.createRef()
	self.isMounted = false

	self.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()

	if fFlagAXCatalogSearchKeepFilters then
		self.filteringDeepLinkRequestId = nil
	end

	if fFlagAXMigrateAllTabToSduiDev then
		self.lastDispatchedSearchCategoryId = nil
		self.lastDispatchedSearchSubcategoryId = nil
	end

	self:setState({ isSearching = false })

	function self.onNavBarSizeChanged(p2)
		if self.resultsListRef.current then
			self.resultsListRef.current.Size = UDim2.new(1, 0, 1, -p2.Y)
		end
	end

	function self.dispatchInitialSearch()
		local searchUuid2 = self.props.searchUuid
		local searchParameters = self.props.searchParameters
		local dispatchSearchWithParameters = self.props.dispatchSearchWithParameters
		local v9 = self.props.fullView == fullView.SceneFullView
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		if v9 then
			self.props.setFullView(
				avatarExperienceAnalytics,
				self.props.avatarRoute.opaque.name,
				fullView.None
			)
		end

		local fetchWidgetInfo = self.props.fetchWidgetInfo
		local networking = self.props.networking
		local queryStringForSearchWidgets = module38.getQueryStringForSearchWidgets(searchParameters)

		if queryStringForSearchWidgets then
			fetchWidgetInfo(networking, queryStringForSearchWidgets)
		end

		local categoryInfo = self.props.categoryInfo

		if not searchParameters.categoryInfo then
			searchParameters = Dash.join(searchParameters, {
				categoryInfo = categoryInfo
			})

			self.props.setSearchParameters(searchUuid2, searchParameters)
		end

		return dispatchSearchWithParameters(
			searchParameters,
			searchUuid2,
			categoryInfo,
			self.props.networking
		)
	end

	function self.setUIFullView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics
		self.props.setFullView(
			avatarExperienceAnalytics,
			self.props.avatarRoute.opaque.name,
			fullView.UIFullView
		)
	end

	function self.confirmSearchCallback(value, p2, p3)
		if
			fFlagAXFixEmptyCatalogSearchChrome
			and (typeof(value) ~= "string" or value:match("%S") == nil)
		then
			if self.isMounted then
				self:setState({ isSearching = false })
			end
		else
			local v9 = searchUuid()
			local categoryInfo = self.props.categoryInfo

			local v10 = self.props.navigation.getParam("searchParams") or {}
			local joined = Dash.join(v10, {
				searchKeyword = value,
				isKeywordSuggestionEnabled = true,
				categoryInfo = categoryInfo
			})

			self.props.setSearchType(v9, RobloxAppEnums.SearchTypes.Catalog)
			self.props.setSearchParameters(v9, joined)

			if module44() then
				if self.props.isPortrait then
					self.setUIFullView()
				end

				local catalogSearch = avatarScreen.CatalogSearch
				module18(self.props.eventIngest, "catalog", value, p2, catalogSearch, p3)
			end

			recentSearchTermsAppStorage.addTerm(value)

			module20.navigateToSearch(self.props.navigation, v9, joined)
		end
	end

	function self.cancelSearchCallback()
		self.props.navigation.navigate(avatarScreen.Catalog)

		if self.isMounted then
			self:setState({ isSearching = false })
		end
	end

	if module46 then
		function self.onClearButtonActivated()
			module20.navigateToSearchLandingFromSearch(self.props.navigation)
		end
	end

	function self.onSearchBarFocused()
		if not self.isMounted then
			return
		end

		self:setState({ isSearching = true })
	end

	function self.changeView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		local newFullViewEnum = module23.getNewFullViewEnum(self.props.fullView)
		self.props.setFullView(
			avatarExperienceAnalytics,
			self.props.avatarRoute.opaque.name,
			newFullViewEnum
		)
	end

	function self.onSameTermConfirmSearch()
		if self.isMounted then
			self:setState({ isSearching = false })
		end
	end

	function self.clearSearchState(p2)
		self.props.dispatchRemoveSearch(p2)
		self.props.pageObjectManager:storePageObject(p2, nil)
	end

	function self.dispatchWidgetSearch()
		local searchParameters = self.props.searchParameters
		local fetchWidgetInfo = self.props.fetchWidgetInfo
		local networking = self.props.networking
		local queryStringForSearchWidgets = module38.getQueryStringForSearchWidgets(searchParameters)

		if queryStringForSearchWidgets then
			fetchWidgetInfo(networking, queryStringForSearchWidgets)
		end
	end

	function self.onCategoryOrSubcategoryChangeById(lastDispatchedSearchCategoryId, lastDispatchedSearchSubcategoryId)
		local catalogCategoryInfoById = module23.getCatalogCategoryInfoById(
			lastDispatchedSearchCategoryId,
			lastDispatchedSearchSubcategoryId
		)

		if fFlagAXMigrateAllTabToSduiDev and catalogCategoryInfoById == nil then
			return
		end

		local v9

		if fFlagAXMigrateAllTabToSduiDev then
			v9 = self.lastDispatchedSearchCategoryId ~= lastDispatchedSearchCategoryId
				or self.lastDispatchedSearchSubcategoryId ~= lastDispatchedSearchSubcategoryId

			if v9 then
				self.lastDispatchedSearchCategoryId = lastDispatchedSearchCategoryId
				self.lastDispatchedSearchSubcategoryId = lastDispatchedSearchSubcategoryId
			end
		else
			v9 = catalogCategoryInfoById ~= self.props.categoryInfo
		end

		if v9 then
			self.dispatchSearchOnCategoryOrSubcategoryChange(catalogCategoryInfoById)

			ttiPerformanceManager.Surface.Marketplace.Root.startTracking()
			organicTTIMilestoneManager.L2.primaryDataStarted()
			organicTTIMilestoneManager.L3.networkFetch()
			self.props.dispatchCatalogTilesLatencyStartTracker(self.props.searchUuid)
		end
	end

	function self.dispatchSearchOnCategoryOrSubcategoryChange(p2)
		local searchUuid2 = self.props.searchUuid
		local searchParameters = self.props.searchParameters
		local dispatchSearch = self.props.dispatchSearch

		local joined = Dash.join(searchParameters, { categoryInfo = Dash.join({}, p2) })

		self.props.setSearchParameters(searchUuid2, joined)

		self.clearSearchState(searchUuid2)

		if p2 and p2.ShowWidgets then
			self.dispatchWidgetSearch()
		end

		return dispatchSearch(searchParameters.searchKeyword, searchUuid2, p2, self.props.networking)
	end
end

function extended:renderSearchBar()
	local searchKeyword = self.props.searchParameters.searchKeyword
	local navBarSize = self.props.navBarSize

	local v8 = not fFlagAXFixSearchBarPortraitBackground or not self.props.isPortrait

	local v9 = not self.props.designTokens and 20 or self.props.designTokens.Size.Size_1200

	local statusBarHeight = self.props.statusBarHeight or 0

	if fFlagAXFixCatalogSearchBarSafeArea and self.props.isPortrait and statusBarHeight > 0 then
		navBarSize += statusBarHeight
		v9 = statusBarHeight
	elseif defineFastFlag and shouldUseDeviceSafeInsets then
		v9 = 0
	end

	local createElement = Roact.createElement
	local v11 = {
		Size = UDim2.new(1, 0, 0, navBarSize),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = module44() and 3 or nil
	}

	local v13 = if fFlagAXFixSearchBarPortraitBackground and fFlagAXMeTabTopScrim and not v8 then Roact.createElement(module11, {
		ZIndex = 0
	}) else nil

	local createElement2 = Roact.createElement
	local v15 = {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}

	local v17 = if self.props.isPortrait then Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v9)
	}) else nil

	local createElement3 = Roact.createElement
	local v19 = {
		backgroundTransparency = not v8 and 1 or self.props.designTokens.Color.Surface.Surface_0.Transparency,
		backgroundColor3 = 0
	}

	local v20 = if v8 then self.props.designTokens.Color.Surface.Surface_0.Color3 else Color3.fromRGB(0, 0, 0)
	v19.backgroundColor3 = v20

	local createElement4 = Roact.createElement
	local searchBarRefsByRef = {
		cancelSearch = self.cancelSearchCallback,
		confirmSearch = self.confirmSearchCallback,
		onFocused = self.onSearchBarFocused,
		placeholderText = self.props.localized.searchPlaceholder,
		isCompactView = true,
		modernUI = true,
		autocomplete = module44(),
		isSearching = self.state.isSearching,
		searchType = RobloxAppEnums.SearchTypes.Catalog,
		initialSearchText = searchKeyword,
		[Roact.Ref] = self.searchBarRef,
		NextSelectionDown = self.resultsListRef,
		forceShowCancelButton = module44(),
		onSameTermConfirmSearch = self.onSameTermConfirmSearch,
		shouldShowRecentSearchTerms = true
	}

	local v23 = if module46 then self.onClearButtonActivated else nil
	searchBarRefsByRef.onClearButtonActivated = v23
	return createElement("Frame", v11, {
		Scrim = v13,
		PaddedFrame = createElement2("Frame", v15, {
			SearchBarPadding = v17,
			SearchBar = createElement3(horizontalPageMargin, v19, {
				createElement4(module12, searchBarRefsByRef)
			})
		})
	})
end

function extended:render()
	local hasEntries = self.props.hasEntries
	local v8 = self.props.fullView == fullView.SceneFullView
	local v9 = self.props.fullView == fullView.UIFullView
	local searchUuid2 = self.props.searchUuid
	local v10 = self.refinementButtonsRef

	if self.props.avatarRoute.current.name == avatarScreen.TryOnManager then
		v10 = self.props.namedRefs[avatarScreen.TryOnManager]
	elseif self.props.avatarRoute.current.name == avatarScreen.LookDetails then
		v10 = self.props.namedRefs[avatarScreen.LookDetails]
	end

	local createElement = Roact.createElement
	local frame = focusable.Frame
	local focusNavigationRefsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		defaultChild = hasEntries and self.resultsListRef or self.searchBarRef,
		[Roact.Ref] = self.props.focusNavigationRef
	}
	local v11 = {
		NavigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function()
				local sortAndFilters = (self.props.navigation.getParam("searchParams") or {}).sortAndFilters

				if sortAndFilters then
					self.props.setSortAndFilters(sortAndFilters)
				else
					self.props.resetSortAndFilters()
				end
			end
		}),
		NavigationEventsLogger = Roact.createElement(module27, {
			pageName = "CatalogSearch"
		}),
		SearchViewExposureLogger = 0,
		AvatarExperienceView = 0
	}

	local v12 = if fFlagAXUnifiedAutocompleteExposureLogging then Roact.createElement(searchViewExposureLogger) else nil
	v11.SearchViewExposureLogger = v12

	local createElement2 = Roact.createElement
	local sceneUIContainerRefsByRef = {
		changeViewFunction = self.changeView,
		allowAdaptiveScrolling = true,
		adaptiveScrollingProps = (fFlagAXHideMenuOnScroll or fFlagAXExpandPeekViewOnFirstScroll) and {
			enableExpandPeekViewOnUpwardScroll = fFlagAXExpandPeekViewOnFirstScroll and true or nil,
			enableAnimatedVisibility = fFlagAXHideMenuOnScroll and true or nil
		} or nil,
		isSceneFullView = v8,
		isUIFullView = v9,
		topBar = self:renderSearchBar(),
		[Roact.Ref] = self.sceneUIContainerRef,
		NextSelectionLeft = self.searchBarRef,
		refinementButtonsRef = self.refinementButtonsRef,
		defaultChildRef = hasEntries and self.resultsListRef or self.searchBarRef,
		multiTryOnBottomBarRef = self.multiTryOnBottomBarRef,
		itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
		showUndoRedo = module45() and true or nil,
		showSaveButton = module45() and fFlagAXEnableManualSaving and true or nil
	}

	local createElement3 = Roact.createElement
	local v16 = {
		defaultFocusRef = self.props.defaultFocusRef,
		analyticsContext = module36.AnalyticsContext.CatalogSearch,
		fromSearch = true,
		searchUuid = searchUuid2,
		onRetry = self.dispatchInitialSearch,
		frameRef = self.resultsListRef,
		NextSelectionUp = self.searchBarRef,
		NextSelectionRight = v10,
		multiTryOnBottomBarRef = self.multiTryOnBottomBarRef,
		onCategoryOrSubcategoryChange = self.onCategoryOrSubcategoryChange,
		onCategoryOrSubcategoryChangeById = self.onCategoryOrSubcategoryChangeById,
		itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
		scrollPerformanceIntervalName = 0
	}

	local v17 = if fFlagAXScrollTelemetryIntegration2 then module15.CatalogSearch else nil
	v16.scrollPerformanceIntervalName = v17
	v11.AvatarExperienceView = createElement2(module26, sceneUIContainerRefsByRef, {
		ResultsList = createElement3(module37, v16)
	})
	return createElement(frame, focusNavigationRefsByRef, v11)
end

function extended:didMount()
	self.isMounted = true

	if fFlagAXCatalogSearchKeepFilters then
		local v8 = self.props.navigation.getParam("searchParams") or {}

		if v8.sortAndFilters then
			self.props.setSortAndFilters(v8.sortAndFilters)
		end
	end

	self.dispatchInitialSearch():catch(function(p2)
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn("Error fetching CatalogSearch results:\n" .. tostring(p2))
		end
	end)
end

function extended:willUnmount()
	self.isMounted = false
	local searchUuid2 = self.props.searchUuid
	self.props.dispatchRemoveSearch(searchUuid2)
	self.props.pageObjectManager:storePageObject(searchUuid2, nil)

	if not (fFlagAXCatalogSearchKeepFilters and self:isLeavingForCatalogDeepLinkWithFilters()) then
		self.props.resetSortAndFilters()
	end
end

function extended:isLeavingForCatalogDeepLinkWithFilters()
	local externalNavigationRequest = self.props.externalNavigationRequest

	if externalNavigationRequest == nil then
		return false
	end

	local v8 = externalNavigationRequest.screen == avatarScreen.Catalog

	local v9 = externalNavigationRequest.requestId == self.filteringDeepLinkRequestId

	return v8 and v9
end

function extended:didUpdate(p2)
	if p2.searchUuid ~= self.props.searchUuid then
		if p2.searchUuid ~= nil then
			self.props.dispatchRemoveSearch(p2.searchUuid)
			self.props.pageObjectManager:storePageObject(p2.searchUuid, nil)
		end

		self.dispatchInitialSearch()
	end

	if fFlagAXCatalogSearchKeepFilters then
		local externalNavigationRequest = self.props.externalNavigationRequest
		local externalNavigationRequest2 = p2.externalNavigationRequest
		local v8

		if externalNavigationRequest == nil then
			v8 = false
		else
			v8 = externalNavigationRequest2 == nil
				or externalNavigationRequest.requestId ~= externalNavigationRequest2.requestId
		end

		if v8 and module14.catalogDeepLinkExists(externalNavigationRequest) then
			self.filteringDeepLinkRequestId = externalNavigationRequest.requestId
		end
	end
end

local function mapStateToProps(data, p2)
	local v8 = data.Search.SearchesInCatalog[p2.searchUuid]
	local items = v8 and v8.items or nil
	local v9 = items and #items ~= 0 and true or false

	local searchKey = module23.getSearchKey(data, p2.searchUuid)

	local v10 = data.DeviceOrientation == deviceOrientationMode.Portrait

	local v11 = {
		categoryInfo = p2.categoryInfo,
		fullView = module28(data, avatarScreen.CatalogSearch),
		hasEntries = v9,
		dataStatus = performFetch.GetStatus(data, searchKey),
		topBarHeight = module10.selectTopBarHeightNoBanners(data),
		statusBarHeight = 0,
		itemDetailsExpanded = 0,
		isPortrait = 0,
		externalNavigationRequest = 0
	}
	local v12 = if fFlagAXFixCatalogSearchBarSafeArea then data.TopBar.statusBarHeight else nil
	v11.statusBarHeight = v12
	v11.itemDetailsExpanded = data.AvatarExperience.Common.ItemDetailsExpanded
	v11.isPortrait = v10

	local v13 = if fFlagAXCatalogSearchKeepFilters then data.AvatarExperience.ExternalNavigationRequest else nil
	v11.externalNavigationRequest = v13
	return v11
end

local function mapDispatchToProps(callback)
	return {
		dispatchSearch = function(p2, p3, p4, p5)
			return callback(module43({
				searchKeyword = p2,
				searchUuid = p3,
				categoryInfo = p4
			}, p5))
		end,
		dispatchSearchWithParameters = function(p2, p3, p4, p5)
			local selectedTopics = p2.sortAndFilters and p2.sortAndFilters.SelectedTopics or {}

			return callback(module43(
				{
					searchKeyword = p2.searchKeyword,
					searchUuid = p3,
					categoryInfo = p4,
					topics = selectedTopics
				},
				p5
			))
		end,
		dispatchRemoveSearch = function(p2)
			callback(module39(p2))
		end,
		setSearchType = function(p2, p3)
			return callback(module17(p2, p3))
		end,
		setSearchParameters = function(p2, p3)
			return callback(module16(p2, p3))
		end,
		setSortAndFilters = function(p2)
			return callback(module40(p2))
		end,
		openItemPrompt = function(p2, p3, p4, p5, p6)
			callback(module30(p2, p3, p4, p5, p6))
		end,
		setItemDetailsPeekViewState = function(p2)
			callback(setItemDetailsPeekViewState(p2))
		end,
		setFullView = function(p2, p3, p4)
			callback(module32(p2, p3, p4))
		end,
		navigateIntoQuickMenu = function(p2, p3)
			callback(module31(p2, p3))
		end,
		resetSortAndFilters = function()
			callback(module41())
		end,
		setTryOnManagerPeekViewState = function(p2)
			callback(setTryOnManagerPeekViewState(p2))
		end,
		fetchWidgetInfo = function(p2, p3)
			callback(module42(p2, p3))
		end,
		dispatchCatalogTilesLatencyStartTracker = function(p2)
			callback(module13.StartTracking(p2))
		end
	}
end

local v8 = module21(
	module25((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))),
	module22.Consumer,
	"pageObjectManager"
)

local v9 = roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService,
	eventIngest = module4
})(v8)

local function CatalogSearchContainer(p2)
	local v10 = useDispatch()
	local v11 = useAvatarRoute()
	local v12 = useNavigation()
	local v13 = module(module35)
	local v14 = module(module3)
	local v15 = useSelector(fn)
	local v16 = useSelector(fn2)
	local name = v11.current.name

	local v17 = module34()
	local v18 = module33({ overlayClosedCallback = v17 })

	local v19 = useLocalization({
		searchPlaceholder = "Search.GlobalSearch.Example.SearchCatalog"
	})

	local v20 = useDesignTokens()

	local v23 = useShouldFetchCartPricingForPurchasePrompt((useSelector((React.useCallback(function(p3)
		if v11.current and v11.current.params then
			return itemData(
				p3.AvatarExperience.Common,
				v11.current.params.itemId,
				v11.current.params.itemType
			)
		end

		return nil
	end, { v11 })))))

	local v24 = React.useCallback(function()
		v10(module30(v14, v13, v17, v12, v11, nil, nil, false, nil, nil, nil, v23))
	end, { v10, v17, v11, v12, v14, v13, v23 })

	local v25 = React.useCallback(function()
		module20.closeFiltersAndItemDetails(v12)
		v12.navigate(avatarScreen.TryOnManager)
	end, { v12 })

	local v26 = React.useCallback(function()
		if v15 == peekViewState.Full or v15 == peekViewState.Extended then
			v10(setTryOnManagerPeekViewState(peekViewState.Brief))
		else
			v10(setTryOnManagerPeekViewState(peekViewState.Full))
		end
	end, { v15, v10 })

	local v27 = #Cryo.Dictionary.values(v16) > 1
	local v28 = if name ~= avatarScreen.TryOnManager and v27 then v25 else nil

	if name == avatarScreen.TryOnManager or name == avatarScreen.LookDetails then
		v28 = v26
	end

	if name ~= avatarScreen.ItemDetails then
		v24 = nil
	end

	local v32 = useTableWrappedCallbackRef((useCatalogSearchFocusNavigationBindings(nil, v24, v28)))

	local v33 = useNavBarSize()

	local v34, v35 = useMostRecentOrDefaultFocusBehavior(v18)
	local v36 = useFocusOnMount(v34)

	local joined = Cryo.Dictionary.join(p2, {
		overlayClosedCallback = v17,
		localized = v19,
		designTokens = v20,
		focusNavigationRef = v32,
		avatarRoute = v11,
		navigation = v12,
		networking = v14,
		tryOnManagerPeekViewState = v15,
		navBarSize = v33
	})

	joined.categoryInfo = useSignalState(module47.getCatalogSearchSelectionStore().selectedCategoryInfo)
	joined.defaultFocusRef = v36

	return React.createElement(
		"Frame",
		{ ref = v35, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
		React.createElement(v9, joined)
	)
end

return CatalogSearchContainer
