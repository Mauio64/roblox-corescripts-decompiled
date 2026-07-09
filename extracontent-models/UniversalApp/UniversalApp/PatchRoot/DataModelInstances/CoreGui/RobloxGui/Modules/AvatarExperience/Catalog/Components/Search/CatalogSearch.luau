local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local Focusable = RoactGamepad.Focusable
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useNavBarSize = require(CorePackages.Workspace.Packages.AppNavBar).useNavBarSize
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useMostRecentOrDefaultFocusBehavior = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local OrganicTTIMilestoneManager = AvatarExperienceTTIPerformance.OrganicTTIMilestoneManager
local AvatarExperienceSearch = require(CorePackages.Workspace.Packages.AvatarExperienceSearch)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local SearchBar = require(Modules.LuaApp.Components.SearchBar)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local catalogSearchEvent = require(Modules.LuaApp.Analytics.Events.catalogSearchEvent)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Common = Modules.AvatarExperience.Common

require(Common.AvatarExperienceState)

local NavigationUtils = require(Common.Components.RoactNavigation.NavigationUtils)
local withContextValue = require(Common.withContextValue)
local PageObjectManagerContext = require(Common.Context.PageObjectManagerContext)
local Utils = require(Common.Utils)
local NamedRefConstants = require(Common.NamedRefConstants)
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local withAvatarRoute = require(Common.Components.RoactNavigation.withAvatarRoute)
local withNamedRefs = require(Common.Context.withNamedRefs)
local Analytics = require(Common.Services.Analytics)
local AvatarExperienceView = require(Common.Components.AvatarExperienceView)
local BoundInputsUpdater = require(Common.Components.BoundInputsUpdater)
local GamepadFocusHandlerForPage = require(Common.Components.GamepadFocusHandlerForPage)
local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local selectIsFullView = require(Common.Selectors.selectIsFullView)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetItemDetailsPeekViewState = AvatarExperienceRodux.Actions.SetItemDetailsPeekViewState
local OpenItemPrompt = require(Common.Thunks.OpenItemPrompt)
local OpenQuickMenu = require(Common.Thunks.OpenQuickMenu)
local SetFullView = require(Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local Catalog = Modules.AvatarExperience.Catalog
local Analytics2 = require(Catalog.Services.Analytics)
local CatalogConstants = require(Catalog.CatalogConstants)
local ResultsList = require(Catalog.Components.Search.ResultsList)
local CatalogUtils = require(Catalog.CatalogUtils)
local RemoveSearchInCatalog = require(Catalog.Actions.RemoveSearchInCatalog)
local SetSortAndFilters = require(Catalog.Actions.SetSortAndFilters)
local ResetSortAndFilters = require(Catalog.Actions.ResetSortAndFilters)
local ResetSortAndFiltersThunk = require(Catalog.Thunks.ResetSortAndFiltersThunk)
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local FetchWidgetInfo = require(Catalog.Thunks.FetchWidgetInfo)
local ApiFetchCatalogSearch = require(Catalog.Thunks.ApiFetchCatalogSearch)
local Flags = Modules.AvatarExperience.Flags
local GetFFlagAvatarAutocompleteEnabledForAll = require(Flags.GetFFlagAvatarAutocompleteEnabledForAll)
local FFlagAXResetAnalyticsMetadataOnFilterReset = require(Flags.FFlagAXResetAnalyticsMetadataOnFilterReset)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXEnableManualSaving = AvatarExperienceFlags.FFlagAXEnableManualSaving
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXMigrateCatalogSearchToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateCatalogSearchToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXExpandPeekViewOnFirstScroll = AvatarExperienceFlags.FFlagAXExpandPeekViewOnFirstScroll
local FFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local RecentSearchTermsAppStorage = AvatarExperienceSearch.Utils.RecentSearchTermsAppStorage
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.ToggleTryOn
}

local function v110(p1) -- line: 155
	return p1.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end
local function v111(p2) -- line: 159
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function useCatalogSearchFocusNavigationBindings(p3, p4: ((...any) -> ...any)?, p5: ((...any) -> ...any)?) -- line: 163
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v126 = ReactFocusNavigation.useEventMap(t1, p3)
	local v127 = React.useMemo(function() -- line: 169
		-- upvalues: FocusNavigationEventNameEnum (copy), p4 (copy), InputHandlers (copy), p5 (copy)
		return {
			[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = if not p4 then nil else {
				handler = InputHandlers.onRelease(p4)
			},
			[FocusNavigationEventNameEnum.ToggleTryOn] = if not p5 then nil else {
				handler = InputHandlers.onRelease(p5)
			}
		}
	end, {
		p4,
		p5
	})

	return ReactFocusNavigation.useEventHandlerMap(v127, v126)
end

local v113 = Roact.PureComponent:extend("CatalogSearch")

v113.validateProps = t.strictInterface({
	searchUuid = t.string,
	searchParameters = t.table,
	isVisible = t.optional(t.boolean),
	fullView = t.optional(t.userdata),
	topBarHeight = t.number,
	dataStatus = t.string,
	hasEntries = t.boolean,
	itemDetailsExpanded = t.optional(t.boolean),
	isPortrait = t.boolean,
	tryOnManagerPeekViewState = t.optional(t.valueOf(PeekViewState)),
	tryOnItems = if not FFlagAXMigrateCatalogSearchToFocusNavigation then t.optional(t.table) else nil,
	categoryInfo = t.optional(t.table),
	dispatchSearch = t.callback,
	dispatchRemoveSearch = t.callback,
	setSearchType = t.callback,
	setSearchParameters = t.callback,
	setSortAndFilters = t.callback,
	openItemPrompt = t.callback,
	setItemDetailsPeekViewState = t.callback,
	setFullView = t.callback,
	navigateIntoQuickMenu = t.callback,
	resetSortAndFilters = t.callback,
	setTryOnManagerPeekViewState = t.callback,
	fetchWidgetInfo = t.callback,
	dispatchCatalogTilesLatencyStartTracker = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else t.callback,
	dispatchSearchWithParameters = t.callback,
	pageObjectManager = t.optional(t.table),
	namedRefs = t.table,
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	analytics = if not FFlagAXMigrateCatalogSearchToFocusNavigation then t.table else nil,
	avatarExperienceAnalytics = t.table,
	catalogAnalytics = if not FFlagAXMigrateCatalogSearchToFocusNavigation then t.table else nil,
	networking = t.callback,
	eventIngest = t.table,
	overlayClosedCallback = t.callback,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	localized = t.table,
	designTokens = t.table,
	focusNavigationRef = if not FFlagAXMigrateCatalogSearchToFocusNavigation then nil else t.table,
	navBarSize = if not FFlagEnableLeftNavOnConsole then nil else t.number,
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback)
})

function v113.init(p6) -- line: 246
	-- upvalues: Roact (copy), AvatarScreen (copy), NamedRefConstants (copy), RoactGamepad (copy), FullView (copy), CatalogUtils (copy), Dash (copy), SearchUuid (copy), RobloxAppEnums (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), catalogSearchEvent (copy), RecentSearchTermsAppStorage (copy), NavigationUtils (copy), Utils (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), OrganicTTIMilestoneManager (copy)
	local v129, v130 = Roact.createBinding(0)

	p6.pillBarScrollOffset = v129
	p6.updatePillBarScrollOffset = v130
	p6.searchBarRef = Roact.createRef()
	p6.sceneUIContainerRef = Roact.createRef()
	p6.resultsListRef = p6.props.namedRefs[AvatarScreen.CatalogSearch .. NamedRefConstants.ItemsList]
	p6.refinementButtonsRef = Roact.createRef()
	p6.multiTryOnBottomBarRef = Roact.createRef()
	p6.isMounted = false
	p6.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()
	p6:setState({
		isSearching = false
	})

	function p6.onNavBarSizeChanged(p7) -- line: 262
		-- upvalues: p6 (copy)
		if p6.resultsListRef.current then
			p6.resultsListRef.current.Size = UDim2.new(1, 0, 1, -p7.Y)
		end
	end
	function p6.dispatchInitialSearch() -- line: 268
		-- upvalues: p6 (copy), FullView (copy), CatalogUtils (copy), Dash (copy)
		local searchUuid = p6.props.searchUuid
		local searchParameters = p6.props.searchParameters
		local dispatchSearchWithParameters = p6.props.dispatchSearchWithParameters
		local v202 = p6.props.fullView == FullView.SceneFullView
		local avatarExperienceAnalytics = p6.props.avatarExperienceAnalytics

		if v202 then
			p6.props.setFullView(avatarExperienceAnalytics, p6.props.avatarRoute.opaque.name, FullView.None)
		end

		local fetchWidgetInfo = p6.props.fetchWidgetInfo
		local networking = p6.props.networking
		local v206 = CatalogUtils.getQueryStringForSearchWidgets(searchParameters)

		if v206 then
			fetchWidgetInfo(networking, v206)
		end

		local categoryInfo = p6.props.categoryInfo

		if not searchParameters.categoryInfo then
			searchParameters = Dash.join(searchParameters, {
				categoryInfo = categoryInfo
			})
			p6.props.setSearchParameters(searchUuid, searchParameters)
		end

		return dispatchSearchWithParameters(searchParameters, searchUuid, categoryInfo, p6.props.networking)
	end
	function p6.setUIFullView() -- line: 299
		-- upvalues: p6 (copy), FullView (copy)
		local avatarExperienceAnalytics = p6.props.avatarExperienceAnalytics

		p6.props.setFullView(avatarExperienceAnalytics, p6.props.avatarRoute.opaque.name, FullView.UIFullView)
	end
	function p6.confirmSearchCallback(p8, p9, p10) -- line: 304
		-- upvalues: SearchUuid (copy), p6 (copy), Dash (copy), RobloxAppEnums (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), AvatarScreen (copy), catalogSearchEvent (copy), RecentSearchTermsAppStorage (copy), NavigationUtils (copy)
		local v212 = SearchUuid()
		local categoryInfo = p6.props.categoryInfo
		local v214 = p6.props.navigation.getParam("searchParams") or {}
		local v215 = Dash.join(v214, {
			isKeywordSuggestionEnabled = true,
			searchKeyword = p8,
			categoryInfo = categoryInfo
		})

		p6.props.setSearchType(v212, RobloxAppEnums.SearchTypes.Catalog)
		p6.props.setSearchParameters(v212, v215)

		if GetFFlagAvatarAutocompleteEnabledForAll() then
			if p6.props.isPortrait then
				p6.setUIFullView()
			end

			local CatalogSearch = AvatarScreen.CatalogSearch

			catalogSearchEvent(p6.props.eventIngest, "catalog", p8, p9, CatalogSearch, p10)
		end

		RecentSearchTermsAppStorage.addTerm(p8)
		NavigationUtils.navigateToSearch(p6.props.navigation, v212, v215)
	end
	function p6.cancelSearchCallback() -- line: 346
		-- upvalues: p6 (copy), AvatarScreen (copy)
		p6.props.navigation.navigate(AvatarScreen.Catalog)

		if p6.isMounted then
			p6:setState({
				isSearching = false
			})
		end
	end
	function p6.onSearchBarFocused() -- line: 356
		-- upvalues: p6 (copy)
		if not p6.isMounted then
			return
		end

		p6:setState({
			isSearching = true
		})
	end
	function p6.changeView() -- line: 366
		-- upvalues: p6 (copy), Utils (copy)
		local avatarExperienceAnalytics = p6.props.avatarExperienceAnalytics
		local v218 = Utils.getNewFullViewEnum(p6.props.fullView)

		p6.props.setFullView(avatarExperienceAnalytics, p6.props.avatarRoute.opaque.name, v218)
	end
	function p6.onSameTermConfirmSearch() -- line: 373
		-- upvalues: p6 (copy)
		if p6.isMounted then
			p6:setState({
				isSearching = false
			})
		end
	end
	function p6.clearSearchState(s1: string) -- line: 381
		-- upvalues: p6 (copy)
		p6.props.dispatchRemoveSearch(s1)
		p6.props.pageObjectManager:storePageObject(s1, nil)
	end
	function p6.dispatchWidgetSearch() -- line: 386
		-- upvalues: p6 (copy), CatalogUtils (copy)
		local searchParameters = p6.props.searchParameters
		local fetchWidgetInfo = p6.props.fetchWidgetInfo
		local networking = p6.props.networking
		local v223 = CatalogUtils.getQueryStringForSearchWidgets(searchParameters)

		if v223 then
			fetchWidgetInfo(networking, v223)
		end
	end
	function p6.onCategoryOrSubcategoryChangeById(s2: string, s3: string) -- line: 396
		-- upvalues: Utils (copy), p6 (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), OrganicTTIMilestoneManager (copy)
		local v226 = Utils.getCatalogCategoryInfoById(s2, s3)

		if v226 ~= p6.props.categoryInfo then
			p6.dispatchSearchOnCategoryOrSubcategoryChange(v226)

			if GetFFlagEnableCatalogTileLoadingLatency() then
				TTIPerformanceManager.Surface.Marketplace.Root.startTracking()
				OrganicTTIMilestoneManager.L2.primaryDataStarted()
				OrganicTTIMilestoneManager.L3.networkFetch()
				p6.props.dispatchCatalogTilesLatencyStartTracker(p6.props.searchUuid)
			end
		end
	end
	function p6.dispatchSearchOnCategoryOrSubcategoryChange(p11) -- line: 414
		-- upvalues: p6 (copy), Dash (copy)
		local searchUuid = p6.props.searchUuid
		local searchParameters = p6.props.searchParameters
		local dispatchSearch = p6.props.dispatchSearch
		local v231 = Dash.join(searchParameters, {
			categoryInfo = Dash.join({}, p11)
		})

		p6.props.setSearchParameters(searchUuid, v231)
		p6.clearSearchState(searchUuid)

		if p11 and p11.ShowWidgets then
			p6.dispatchWidgetSearch()
		end

		return dispatchSearch(searchParameters.searchKeyword, searchUuid, p11, p6.props.networking)
	end
end

if not FFlagAXMigrateCatalogSearchToFocusNavigation then
	function v113.getInputBindings(p12) -- line: 435
		-- upvalues: AvatarScreenProperties (copy), Cryo (copy), RoactGamepad (copy), NavigationUtils (copy), AvatarScreen (copy), FFlagAXMISEnableMultiShopping (copy), PeekViewState (copy)
		local avatarRoute = p12.props.avatarRoute
		local name = avatarRoute.current.name
		local isMultiTryOn = AvatarScreenProperties[avatarRoute.opaque.name].isMultiTryOn
		local v135 = #Cryo.Dictionary.values(p12.props.tryOnItems) > 1
		local t2 = {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 443
				-- upvalues: NavigationUtils (copy), p12 (copy)
				NavigationUtils.closeFocusedScreen(p12.props.navigation)
			end),
			OpenTryOnManager = if name == AvatarScreen.TryOnManager or (not isMultiTryOn and not FFlagAXMISEnableMultiShopping or not v135) then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 449
				-- upvalues: NavigationUtils (copy), p12 (copy), AvatarScreen (copy)
				NavigationUtils.closeFiltersAndItemDetails(p12.props.navigation)
				p12.props.navigation.navigate(AvatarScreen.TryOnManager)
			end, {
				key = "Feature.Catalog.Label.TryOns"
			})
		}

		if name == AvatarScreen.ItemDetails then
			return (Cryo.Dictionary.join(t2, {
				OpenItemPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, function() -- line: 460
					-- upvalues: p12 (copy), avatarRoute (copy)
					p12.props.openItemPrompt(p12.props.networking, p12.props.catalogAnalytics, p12.props.overlayClosedCallback, p12.props.navigation, avatarRoute)
				end, {
					key = "Feature.Catalog.Action.Buy"
				}),
				OpenCatalogContextMenu = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, function() -- line: 471
					-- upvalues: p12 (copy), AvatarScreen (copy), avatarRoute (copy)
					p12.props.navigation.navigate(AvatarScreen.CatalogContextMenu, {
						itemId = avatarRoute.current.params.itemId,
						itemType = avatarRoute.current.params.itemType,
						onOverlayClosed = p12.props.overlayClosedCallback
					})
				end, {
					key = "Feature.Catalog.Action.ItemOptions"
				})
			}))
		end

		if name == AvatarScreen.TryOnManager then
			return (Cryo.Dictionary.join(t2, {
				OpenCloseTryOnManager = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 483
					-- upvalues: p12 (copy), PeekViewState (copy)
					local tryOnManagerPeekViewState = p12.props.tryOnManagerPeekViewState

					if tryOnManagerPeekViewState == PeekViewState.Full or tryOnManagerPeekViewState == PeekViewState.Extended then
						p12.props.setTryOnManagerPeekViewState(PeekViewState.Brief)

						return
					end

					p12.props.setTryOnManagerPeekViewState(PeekViewState.Full)
				end, {
					key = "Feature.Catalog.Label.TryOns"
				})
			}))
		end

		if name == AvatarScreen.LookDetails then
			t2 = Cryo.Dictionary.join(t2, {
				OpenCloseTryOnManager = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 496
					-- upvalues: p12 (copy), PeekViewState (copy)
					local tryOnManagerPeekViewState = p12.props.tryOnManagerPeekViewState

					if tryOnManagerPeekViewState == PeekViewState.Full or tryOnManagerPeekViewState == PeekViewState.Extended then
						p12.props.setTryOnManagerPeekViewState(PeekViewState.Brief)

						return
					end

					p12.props.setTryOnManagerPeekViewState(PeekViewState.Full)
				end, {
					key = "Feature.Catalog.Label.TryOns"
				})
			})
		end

		return t2
	end
end

function v113.renderSearchBar(p13) -- line: 513
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), HorizontalPageMargin (copy), SearchBar (copy), RobloxAppEnums (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	local searchKeyword = p13.props.searchParameters.searchKeyword
	local v139 = if not FFlagEnableLeftNavOnConsole then p13.props.topBarHeight else p13.props.navBarSize
	local n1 = 20

	if p13.props.designTokens then
		n1 = if not FFlagRenameDeprecatedUIBloxTokens then p13.props.designTokens.Global.Space_600 else p13.props.designTokens.Size.Size_1200
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v139),
		ZIndex = if not GetFFlagAvatarAutocompleteEnabledForAll() then nil else 3
	}, {
		PaddedFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			SearchBarPadding = if not p13.props.isPortrait then nil else Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, n1)
			}),
			SearchBar = Roact.createElement(HorizontalPageMargin, {
				backgroundTransparency = not FFlagEnableLeftNavOnConsole and 1 or ((if not FFlagRenameDeprecatedUIBloxTokens then p13.props.designTokens.Semantic.Color.Background.Default else p13.props.designTokens.Color.Surface.Surface_0)).Transparency,
				backgroundColor3 = if not FFlagEnableLeftNavOnConsole then Color3.fromRGB(0, 0, 0) else ((if not FFlagRenameDeprecatedUIBloxTokens then p13.props.designTokens.Semantic.Color.Background.Default else p13.props.designTokens.Color.Surface.Surface_0)).Color3
			}, { Roact.createElement(SearchBar, {
				cancelSearch = p13.cancelSearchCallback,
				confirmSearch = p13.confirmSearchCallback,
				onFocused = p13.onSearchBarFocused,
				placeholderText = p13.props.localized.searchPlaceholder,
				isCompactView = true,
				modernUI = true,
				autocomplete = GetFFlagAvatarAutocompleteEnabledForAll(),
				isSearching = p13.state.isSearching,
				searchType = RobloxAppEnums.SearchTypes.Catalog,
				initialSearchText = searchKeyword,
				[Roact.Ref] = p13.searchBarRef,
				NextSelectionDown = p13.resultsListRef,
				focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p13.props.focusController else nil,
				forceShowCancelButton = GetFFlagAvatarAutocompleteEnabledForAll(),
				onSameTermConfirmSearch = p13.onSameTermConfirmSearch,
				shouldShowRecentSearchTerms = true
			}) })
		})
	})
end
function v113.render(p14) -- line: 580
	-- upvalues: FullView (copy), AvatarScreen (copy), Roact (copy), Focusable (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateCatalogSearchToFocusNavigation (copy), BoundInputsUpdater (copy), RoactNavigation (copy), NavigationEventsLogger (copy), AvatarExperienceView (copy), FFlagAXHideMenuOnScroll (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), GetFFlagAXEnableSlotBasedEditor (copy), FFlagAXEnableManualSaving (copy), GamepadFocusHandlerForPage (copy), ResultsList (copy), FFlagLuaAppsDefaultSelection (copy), CatalogConstants (copy)
	local hasEntries = p14.props.hasEntries
	local v143 = p14.props.fullView == FullView.SceneFullView
	local v144 = p14.props.fullView == FullView.UIFullView
	local searchUuid = p14.props.searchUuid
	local refinementButtonsRef = p14.refinementButtonsRef

	if p14.props.avatarRoute.current.name == AvatarScreen.TryOnManager then
		refinementButtonsRef = p14.props.namedRefs[AvatarScreen.TryOnManager]
	elseif p14.props.avatarRoute.current.name == AvatarScreen.LookDetails then
		refinementButtonsRef = p14.props.namedRefs[AvatarScreen.LookDetails]
	end

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p14.props.focusController else nil,
		defaultChild = hasEntries and p14.resultsListRef or p14.searchBarRef,
		inputBindings = if not FFlagAXMigrateCatalogSearchToFocusNavigation then p14:getInputBindings() else nil,
		[Roact.Ref] = if not FFlagAXMigrateCatalogSearchToFocusNavigation then nil else p14.props.focusNavigationRef
	}, {
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil,
		NavigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function() -- line: 604
				-- upvalues: p14 (copy)
				local sortAndFilters = (p14.props.navigation.getParam("searchParams") or {}).sortAndFilters

				if sortAndFilters then
					p14.props.setSortAndFilters(sortAndFilters)

					return
				end

				p14.props.resetSortAndFilters()
			end
		}),
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "CatalogSearch"
		}),
		AvatarExperienceView = Roact.createElement(AvatarExperienceView, {
			changeViewFunction = p14.changeView,
			allowAdaptiveScrolling = true,
			adaptiveScrollingProps = if not FFlagAXHideMenuOnScroll and not FFlagAXExpandPeekViewOnFirstScroll then nil else {
				enableExpandPeekViewOnUpwardScroll = not not FFlagAXExpandPeekViewOnFirstScroll or nil,
				enableAnimatedVisibility = not not FFlagAXHideMenuOnScroll or nil
			},
			isSceneFullView = v143,
			isUIFullView = v144,
			topBar = p14:renderSearchBar(),
			[Roact.Ref] = p14.sceneUIContainerRef,
			NextSelectionLeft = p14.searchBarRef,
			refinementButtonsRef = p14.refinementButtonsRef,
			defaultChildRef = hasEntries and p14.resultsListRef or p14.searchBarRef,
			multiTryOnBottomBarRef = p14.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = p14.itemDetailsPeekViewRefs,
			showUndoRedo = not not GetFFlagAXEnableSlotBasedEditor() or nil,
			showSaveButton = GetFFlagAXEnableSlotBasedEditor() and not not FFlagAXEnableManualSaving or nil
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
				focusController = p14.props.focusController
			}) else nil,
			ResultsList = Roact.createElement(ResultsList, {
				fromSearch = true,
				defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p14.props.defaultFocusRef,
				analyticsContext = CatalogConstants.AnalyticsContext.CatalogSearch,
				searchUuid = searchUuid,
				onRetry = p14.dispatchInitialSearch,
				frameRef = p14.resultsListRef,
				NextSelectionUp = p14.searchBarRef,
				NextSelectionRight = refinementButtonsRef,
				multiTryOnBottomBarRef = p14.multiTryOnBottomBarRef,
				onCategoryOrSubcategoryChange = p14.onCategoryOrSubcategoryChange,
				onCategoryOrSubcategoryChangeById = p14.onCategoryOrSubcategoryChangeById,
				itemDetailsPeekViewRefs = p14.itemDetailsPeekViewRefs
			})
		})
	})
end
function v113.didMount(p15) -- line: 664
	-- upvalues: UserInputService (copy), isGamepadInput (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	p15.isMounted = true
	p15.dispatchInitialSearch():catch(function(p16) -- line: 666
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn("Error fetching CatalogSearch results:\n" .. tostring(p16))
		end
	end)

	local LastInputType = UserInputService:GetLastInputType()
	local v149 = LastInputType and isGamepadInput(LastInputType)

	if not FFlagAXMigrateAXToGlobalAutofocus and v149 then
		p15.props.focusController.captureFocus()
	end
end
function v113.willUnmount(p17) -- line: 681
	p17.isMounted = false

	local searchUuid = p17.props.searchUuid

	p17.props.dispatchRemoveSearch(searchUuid)
	p17.props.pageObjectManager:storePageObject(searchUuid, nil)
	p17.props.resetSortAndFilters()
end
function v113.didUpdate(p18, p19) -- line: 692
	if p19.searchUuid ~= p18.props.searchUuid then
		if p19.searchUuid ~= nil then
			p18.props.dispatchRemoveSearch(p19.searchUuid)
			p18.props.pageObjectManager:storePageObject(p19.searchUuid, nil)
		end

		p18.dispatchInitialSearch()
	end
end

local function mapStateToProps(p20, p21) -- line: 703
	-- upvalues: Utils (copy), DeviceOrientationMode (copy), selectIsFullView (copy), AvatarScreen (copy), PerformFetch (copy), TopBar (copy), FFlagAXMigrateCatalogSearchToFocusNavigation (copy)
	local v156 = p20.Search.SearchesInCatalog[p21.searchUuid]
	local v157 = v156 and v156.items or nil
	local v158 = not not v157 and (#v157 ~= 0 or false)
	local v159 = Utils.getSearchKey(p20, p21.searchUuid)
	local v160 = p20.DeviceOrientation == DeviceOrientationMode.Portrait

	return {
		categoryInfo = p21.categoryInfo,
		fullView = selectIsFullView(p20, AvatarScreen.CatalogSearch),
		hasEntries = v158,
		dataStatus = PerformFetch.GetStatus(p20, v159),
		topBarHeight = TopBar.selectTopBarHeightNoBanners(p20),
		itemDetailsExpanded = p20.AvatarExperience.Common.ItemDetailsExpanded,
		isPortrait = v160,
		tryOnManagerPeekViewState = if not FFlagAXMigrateCatalogSearchToFocusNavigation then p20.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState else nil,
		tryOnItems = if not FFlagAXMigrateCatalogSearchToFocusNavigation then p20.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems else nil
	}
end
local function mapDispatchToProps(p22) -- line: 732
	-- upvalues: ApiFetchCatalogSearch (copy), RemoveSearchInCatalog (copy), SetSearchType (copy), SetSearchParameters (copy), SetSortAndFilters (copy), OpenItemPrompt (copy), SetItemDetailsPeekViewState (copy), SetFullView (copy), OpenQuickMenu (copy), FFlagAXResetAnalyticsMetadataOnFilterReset (copy), ResetSortAndFiltersThunk (copy), ResetSortAndFilters (copy), SetTryOnManagerPeekViewState (copy), FetchWidgetInfo (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), CatalogTilesLatencyTracker (copy)
	return {
		dispatchSearch = function(p23, p24, p25, p26) -- line: 734
			-- upvalues: p22 (copy), ApiFetchCatalogSearch (copy)
			return p22(ApiFetchCatalogSearch({
				searchKeyword = p23,
				searchUuid = p24,
				categoryInfo = p25
			}, p26))
		end,
		dispatchSearchWithParameters = function(p27, p28, p29, p30) -- line: 741
			-- upvalues: p22 (copy), ApiFetchCatalogSearch (copy)
			local t3 = {}

			if p27.sortAndFilters then
				t3 = p27.sortAndFilters.SelectedTopics or {}
			end

			return p22(ApiFetchCatalogSearch({
				searchKeyword = p27.searchKeyword,
				searchUuid = p28,
				categoryInfo = p29,
				topics = t3
			}, p30))
		end,
		dispatchRemoveSearch = function(p31) -- line: 754
			-- upvalues: p22 (copy), RemoveSearchInCatalog (copy)
			p22(RemoveSearchInCatalog(p31))
		end,
		setSearchType = function(p32, p33) -- line: 758
			-- upvalues: p22 (copy), SetSearchType (copy)
			return p22(SetSearchType(p32, p33))
		end,
		setSearchParameters = function(p34, p35) -- line: 762
			-- upvalues: p22 (copy), SetSearchParameters (copy)
			return p22(SetSearchParameters(p34, p35))
		end,
		setSortAndFilters = function(p36) -- line: 766
			-- upvalues: p22 (copy), SetSortAndFilters (copy)
			return p22(SetSortAndFilters(p36))
		end,
		openItemPrompt = function(p37, p38, p39, p40, p41) -- line: 770
			-- upvalues: p22 (copy), OpenItemPrompt (copy)
			p22(OpenItemPrompt(p37, p38, p39, p40, p41))
		end,
		setItemDetailsPeekViewState = function(p42) -- line: 774
			-- upvalues: p22 (copy), SetItemDetailsPeekViewState (copy)
			p22(SetItemDetailsPeekViewState(p42))
		end,
		setFullView = function(p43, p44, p45) -- line: 778
			-- upvalues: p22 (copy), SetFullView (copy)
			p22(SetFullView(p43, p44, p45))
		end,
		navigateIntoQuickMenu = function(p46, p47) -- line: 782
			-- upvalues: p22 (copy), OpenQuickMenu (copy)
			p22(OpenQuickMenu(p46, p47))
		end,
		resetSortAndFilters = function() -- line: 786
			-- upvalues: FFlagAXResetAnalyticsMetadataOnFilterReset (copy), p22 (copy), ResetSortAndFiltersThunk (copy), ResetSortAndFilters (copy)
			if FFlagAXResetAnalyticsMetadataOnFilterReset then
				p22(ResetSortAndFiltersThunk())

				return
			end

			p22(ResetSortAndFilters())
		end,
		setTryOnManagerPeekViewState = function(p48) -- line: 794
			-- upvalues: p22 (copy), SetTryOnManagerPeekViewState (copy)
			p22(SetTryOnManagerPeekViewState(p48))
		end,
		fetchWidgetInfo = function(p49, p50) -- line: 798
			-- upvalues: p22 (copy), FetchWidgetInfo (copy)
			p22(FetchWidgetInfo(p49, p50))
		end,
		dispatchCatalogTilesLatencyStartTracker = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else function(p51) -- line: 803
			-- upvalues: p22 (copy), CatalogTilesLatencyTracker (copy)
			p22((CatalogTilesLatencyTracker.StartTracking(p51)))
		end
	}
end

local v116 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v113)

if not FFlagAXMigrateCatalogSearchToFocusNavigation then
	v116 = withAvatarRoute((withNavigation(v116)))
end

local v117 = withContextValue(withNamedRefs(v116), PageObjectManagerContext.Consumer, "pageObjectManager")
local u118 = if not FFlagAXMigrateCatalogSearchToFocusNavigation then RoactServices.connect({
	analytics = RoactAnalytics,
	catalogAnalytics = Analytics2,
	avatarExperienceAnalytics = Analytics,
	networking = RoactNetworking,
	eventIngest = AppEventIngestService
})(v117) else RoactServices.connect({
	avatarExperienceAnalytics = Analytics,
	eventIngest = AppEventIngestService
})(v117)

if FFlagAXMigrateCatalogSearchToFocusNavigation then
	local function CatalogSearchContainer(p52) -- line: 835
		-- upvalues: useDispatch (copy), useAvatarRoute (copy), useNavigation (copy), useRoactService (copy), Analytics2 (copy), RoactNetworking (copy), useSelector (copy), v110 (copy), v111 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), useLocalization (copy), useDesignTokens (copy), OpenItemPrompt (copy), NavigationUtils (copy), AvatarScreen (copy), PeekViewState (copy), SetTryOnManagerPeekViewState (copy), AvatarScreenProperties (copy), Cryo (copy), FFlagAXMISEnableMultiShopping (copy), useCatalogSearchFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), FFlagEnableLeftNavOnConsole (copy), useNavBarSize (copy), FFlagLuaAppsDefaultSelection (copy), useMostRecentOrDefaultFocusBehavior (copy), useFocusOnMount (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), u118 (ref)
		local v163 = useDispatch()
		local v164 = useAvatarRoute()
		local v165 = useNavigation()
		local v166 = useRoactService(Analytics2)
		local v167 = useRoactService(RoactNetworking)
		local v168 = useSelector(v110)
		local v169 = useSelector(v111)
		local name = v164.current.name
		local v171 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
		local v172 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v171 else nil)
		local v173 = useAvatarExperienceFocusNavigationBindings({
			overlayClosedCallback = v172
		})
		local v174 = useLocalization({
			searchPlaceholder = "Search.GlobalSearch.Example.SearchCatalog"
		})
		local v175 = useDesignTokens()
		local v176 = React.useCallback(function() -- line: 863
			-- upvalues: v163 (copy), OpenItemPrompt (copy), v167 (copy), v166 (copy), v172 (copy), v165 (copy), v164 (copy)
			v163(OpenItemPrompt(v167, v166, v172, v165, v164))
		end, {
			v163,
			v172,
			v164,
			v165,
			v167,
			v166
		})
		local v177 = React.useCallback(function() -- line: 877
			-- upvalues: NavigationUtils (copy), v165 (copy), AvatarScreen (copy)
			NavigationUtils.closeFiltersAndItemDetails(v165)
			v165.navigate(AvatarScreen.TryOnManager)
		end, { v165 })
		local v178 = React.useCallback(function() -- line: 882
			-- upvalues: v168 (copy), PeekViewState (copy), v163 (copy), SetTryOnManagerPeekViewState (copy)
			if v168 == PeekViewState.Full or v168 == PeekViewState.Extended then
				v163(SetTryOnManagerPeekViewState(PeekViewState.Brief))

				return
			end

			v163(SetTryOnManagerPeekViewState(PeekViewState.Full))
		end, {
			v168,
			v163
		})
		local isMultiTryOn = AvatarScreenProperties[v164.opaque.name].isMultiTryOn
		local v180 = #Cryo.Dictionary.values(v169) > 1
		local v181 = nil

		if name ~= AvatarScreen.TryOnManager and ((isMultiTryOn or FFlagAXMISEnableMultiShopping) and v180) then
			v181 = v177
		end

		if name == AvatarScreen.TryOnManager or name == AvatarScreen.LookDetails then
			v181 = v178
		end

		local v182 = useCatalogSearchFocusNavigationBindings(nil, if name ~= AvatarScreen.ItemDetails then nil else v176, v181)
		local v183 = useTableWrappedCallbackRef(v182)
		local v184 = if not FFlagEnableLeftNavOnConsole then nil else useNavBarSize()
		local v185 = nil
		local v186 = nil

		if FFlagLuaAppsDefaultSelection then
			local v187

			v187, v186 = useMostRecentOrDefaultFocusBehavior(v173)
			v185 = useFocusOnMount(v187)
		end

		local v188 = Cryo.Dictionary.join(p52, {
			focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v171 else nil,
			overlayClosedCallback = v172,
			localized = v174,
			designTokens = v175,
			focusNavigationRef = v183,
			avatarRoute = v164,
			navigation = v165,
			networking = v167,
			tryOnManagerPeekViewState = v168,
			navBarSize = if not FFlagEnableLeftNavOnConsole then nil else v184
		})
		local v189 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()

		v188.categoryInfo = useSignalState(v189.selectedCategoryInfo)
		v188.defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else v185

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			ref = if not FFlagLuaAppsDefaultSelection then v173 else v186,
			Size = UDim2.fromScale(1, 1)
		}, React.createElement(u118, v188))
	end

	return CatalogSearchContainer
end

local function CatalogSearchContainer(p53) -- line: 950
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), useLocalization (copy), useDesignTokens (copy), Cryo (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), u118 (ref)
	local v191 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local v192 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v191 else nil)
	local v193 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v192
	})
	local v194 = useLocalization({
		searchPlaceholder = "Search.GlobalSearch.Example.SearchCatalog"
	})
	local v195 = useDesignTokens()
	local v196 = Cryo.Dictionary.join(p53, {
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v191 else nil,
		overlayClosedCallback = v192,
		localized = v194,
		designTokens = v195
	})
	local v197 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()

	v196.categoryInfo = useSignalState(v197.selectedCategoryInfo)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v193,
		Size = UDim2.fromScale(1, 1)
	}, React.createElement(u118, v196))
end

return CatalogSearchContainer
