local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local getPageMargin = UIBlox.App.Container.getPageMargin
local withGridConfig_DEPRECATED = UIBlox.Core.Layout.Grid.withGridConfig_DEPRECATED
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local FFlagEnableAppNavGamepadRemoval = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAppNavGamepadRemoval
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Focusable = RoactGamepad.Focusable
local RoactAnalyticsTopBar = require(Modules.LuaApp.Services.RoactAnalyticsTopBar)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local VerticalEfficiencyExperimentation = require(CorePackages.Workspace.Packages.DiscoveryUtils).VerticalEfficiencyExperimentation
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local SearchConstants = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.Search.SearchConstants
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local ConfirmSearch = require(Modules.LuaApp.Thunks.ConfirmSearch)
local AppPage = require(Modules.LuaApp.AppPage)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local SetTopBarHeight = require(Modules.LuaApp.Actions.SetTopBarHeight)
local Display = require(CorePackages.Workspace.Packages.Display)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Constants = require(Modules.LuaApp.Constants)
local AppPageLocalizationKeys = require(Modules.LuaApp.AppPageLocalizationKeys)
local SearchBar = require(Modules.LuaApp.Components.SearchBar)
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local search = require(Modules.LuaApp.Analytics.Events.search)
local wrapComponent = require(Modules.LuaApp.Common.wrapComponent)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useBannerContainer = require(Modules.LuaApp.Components.Banner.useBannerContainer)
local UseGameDetailsPeekView = require(Modules.LuaApp.Flags.UseGameDetailsPeekView)
local withTopBarSearchSignal = require(Modules.LuaApp.Context.withTopBarSearchSignal)
local SignalConnection = require(Modules.LuaApp.Components.SignalConnection)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local shouldShowProfileInHeaderBar = require(Modules.LuaApp.Components.TopBar.Utils.shouldShowProfileInHeaderBar)
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local SearchButton = require(script.Parent.Buttons.SearchButton)
local LayoutConfig = require(CorePackages.Workspace.Packages.RobloxAppEnums).LayoutConfig
local AppHeaderBar = require(CorePackages.Workspace.Packages.AppHeaderBar).AppHeaderBar
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local GetFFlagAvatarAutocompleteEnabledForAll = require(Modules.AvatarExperience.Flags.GetFFlagAvatarAutocompleteEnabledForAll)
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagSearchOmniAutocompletePageIXP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePageIXP
local GetFFlagLuaAppFixAppNavHeaderIconsAlignment = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppFixAppNavHeaderIconsAlignment
local FFlagLuaAppMoveProfileIntoTopBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBar
local FFlagLuaAppMoveProfileIntoTopBarIXP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBarIXP
local v64 = game:DefineFastString("LuaAppSlpIxpLayer", "Growth.Omnisearch.SearchLandingPage")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagAppIaStatusBar = SharedFlags.FFlagAppIaStatusBar
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagLuaAppCompositionTopBarFullBleed = SharedFlags.FFlagLuaAppCompositionTopBarFullBleed
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v74 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local v78 = game:DefineFastFlag("LuaAppEnableSlpForVr", false)
local shouldShowLeftHeader = nil

if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
	shouldShowLeftHeader = require(CorePackages.Workspace.Packages.FlyoutSidePanel).Utils.shouldShowLeftHeader
end

local NAV_BAR_SIZE = Constants.NAV_BAR_SIZE
local NON_COMPACT_SEARCH_BAR_SIZE = SearchConstants.NON_COMPACT_SEARCH_BAR_SIZE
local v82 = if not FFlagEnableAppNavGamepadRemoval then {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
} else nil
local v83 = Roact.Component:extend("TopBarContainer")

v83.validateProps = t.strictInterface({
	searchType = t.string,
	ZIndex = t.number,
	hideSiteMessageBanner = t.boolean,
	forceCompactMode = t.boolean,
	transparentBackground = t.boolean,
	searchParameters = t.optional(t.table),
	onConfirmSearchCallback = t.optional(t.callback),
	titleText = t.optional(t.string),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	leftItem = t.optional(t.any),
	centerItem = t.optional(t.any),
	rightItems = t.optional(t.array(t.any)),
	isSecondary = t.optional(t.boolean),
	useParentSizeForCenterItem = t.optional(t.boolean),
	setDefaultRefOverride = t.optional(t.callback),
	gridConfig = t.optional(t.table),
	focusController = if not FFlagEnableAppNavGamepadRemoval then t.optional(t.table) else nil,
	totalBannerHeight = t.optional(t.number),
	bannerContainer = t.optional(t.table),
	isSpatial = t.optional(t.boolean),
	screenSize = t.Vector2,
	formFactor = t.string,
	currentRoute = t.table,
	showSearchBar = t.boolean,
	statusBarHeight = t.number,
	opaquePage = t.optional(t.string),
	confirmSearch = t.callback,
	setTopBarHeight = t.callback,
	analytics = t.table,
	sessionService = t.optional(t.union(t.Instance, t.table)),
	eventIngest = t.table,
	enableNotifications = t.boolean,
	enableSearch = t.boolean,
	enableSearchAutoComplete = t.boolean,
	shouldShowSearchLandingPage = if not FFlagSearchOmniAutocompletePageIXP then nil else t.optional(t.boolean),
	navigation = t.table,
	avatarRoute = t.optional(t.table),
	forwardRef = t.optional(t.table),
	shouldNavigateToSearchLandingPage = t.optional(t.boolean),
	sideMarginOverride = t.optional(t.number),
	tag = t.optional(t.string),
	tokens = t.table
})
v83.defaultProps = {
	enableSearch = false,
	ZIndex = 2,
	onConfirmSearchCallback = nil,
	hideSiteMessageBanner = false,
	forceCompactMode = false,
	transparentBackground = false,
	searchType = SearchTypes.Games,
	rightItems = {}
}

local function applyTokenScaling(n1: number, p1) -- line: 227
	return n1 * p1.Config.UI.Scale
end
local function calculateNavBarSize(p2) -- line: 231
	-- upvalues: NAV_BAR_SIZE (copy)
	return NAV_BAR_SIZE * p2.Config.UI.Scale
end
local function calculateTopBarHeight(p3, _) -- line: 235
	-- upvalues: NAV_BAR_SIZE (copy), LayoutConfig (copy)
	local statusBarHeight = p3.statusBarHeight
	local tokens = p3.tokens

	return statusBarHeight + NAV_BAR_SIZE * tokens.Config.UI.Scale + math.round(p3.totalBannerHeight) + 2 * p3.gridConfig[LayoutConfig.Keys.PaddingVertical]
end

function v83.shouldUpdate(p5, p6, p7) -- line: 252
	-- upvalues: Dash (copy)
	if p7 ~= p5.state then
		return true
	end

	if p6 == p5.props then
		return false
	end

	for k, v in pairs(p6) do
		if k ~= "rightItems" and v ~= p5.props[k] then
			return true
		end
	end

	for k, v in pairs(p5.props) do
		if k ~= "rightItems" and v ~= p6[k] then
			return true
		end
	end

	return not Dash.shallowEqual(p5.props.rightItems, p6.rightItems)
end
function v83.getPageOwner(p8) -- line: 276
	return p8.props.navigation.state.routeName
end

local function isTopPage(p9) -- line: 281
	-- upvalues: FFlagAppIaHomeSubTab (copy), NavigationRodux (copy), Cryo (copy), AppNavBar (copy)
	local currentRoute = p9.currentRoute
	local name = currentRoute[#currentRoute].name
	local v118 = if not p9.avatarRoute then p9.opaquePage else p9.avatarRoute.opaque.name
	local routeName = p9.navigation.state.routeName

	if FFlagAppIaHomeSubTab and routeName == NavigationRodux.Constants.HomeContainerName then
		return Cryo.List.find(AppNavBar.Constants.HOME_CONTAINER_SUB_TAB_PAGES, name) ~= nil
	end

	return routeName == name or routeName == v118
end

function v83.updateTopBarHeight(p10, p11, p12) -- line: 303
	-- upvalues: NAV_BAR_SIZE (copy), LayoutConfig (copy), isTopPage (copy), Display (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), VisibilityControl (copy)
	local props = p10.props
	local _ = p10.state
	local statusBarHeight = props.statusBarHeight
	local tokens = props.tokens
	local v127 = statusBarHeight + NAV_BAR_SIZE * tokens.Config.UI.Scale + math.round(props.totalBannerHeight) + 2 * props.gridConfig[LayoutConfig.Keys.PaddingVertical]
	local v128 = isTopPage(p10.props)

	if p11 and (p12 and p11.navigation == p10.props.navigation) then
		local statusBarHeight2 = p11.statusBarHeight
		local tokens2 = p11.tokens
		local v131 = statusBarHeight2 + NAV_BAR_SIZE * tokens2.Config.UI.Scale + math.round(p11.totalBannerHeight) + 2 * p11.gridConfig[LayoutConfig.Keys.PaddingVertical]
		local v132 = isTopPage(p11)

		if v131 == v127 and v128 == v132 then
			return
		end
	end

	if v128 then
		Display.GetDisplayStore().setTopBarHeight(v127)
		p10.props.setTopBarHeight(v127)

		if FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
			VisibilityControl.setScrollDistance(v127)
		end
	end
end
function v83.init(p13) -- line: 324
	-- upvalues: Roact (copy), FFlagEnableAppNavGamepadRemoval (copy), RoactGamepad (copy), UserInputService (copy)
	p13.searchBarRef = Roact.createRef()
	p13.isMounted = false
	p13.rightItemRefs = if not FFlagEnableAppNavGamepadRemoval then RoactGamepad.createRefCache() else nil
	p13.itemDefaultChildRefs = if not FFlagEnableAppNavGamepadRemoval then RoactGamepad.createRefCache() else nil
	p13.leftItemRef = if not FFlagEnableAppNavGamepadRemoval then Roact.createRef() else nil
	p13.centerItemRef = if not FFlagEnableAppNavGamepadRemoval then Roact.createRef() else nil
	p13.buttonVisibilityCallbacks = {}
	p13.state = {
		isSearching = false,
		absolutePosition = Vector2.new(0, 0),
		lastInputType = if not FFlagEnableAppNavGamepadRemoval then UserInputService:GetLastInputType() else nil,
		hiddenItems = {}
	}
	p13:bindFunctions()
	p13:updateTopBarHeight()
end
function v83.bindFunctions(p14) -- line: 348
	-- upvalues: AvatarScreen (copy), SearchTypes (copy), search (copy), SessionType (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), DiscoveryUtils (copy), FFlagEnableAppNavGamepadRemoval (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy)
	local currentRoute = p14.props.currentRoute
	local name = currentRoute[#currentRoute].name

	function p14.onSearchButtonActivated() -- line: 352
		-- upvalues: p14 (copy), name (copy), AvatarScreen (copy)
		if not p14.isMounted then
			return
		end

		p14:setIsSearching(true)
		p14.props.analytics.reportSearchButtonClick(name)

		if p14.props.shouldNavigateToSearchLandingPage then
			p14:setIsSearching(false)
			p14.props.navigation.navigate(AvatarScreen.CatalogSearchLanding)
		end
	end
	function p14.onExitSearch() -- line: 367
		-- upvalues: p14 (copy)
		if not p14.isMounted then
			return
		end

		p14:setIsSearching(false)
	end
	function p14.cancelSearchCallback() -- line: 375
		-- upvalues: p14 (copy), SearchTypes (copy), search (copy), name (copy)
		if not p14.isMounted then
			return
		end

		local searchType = p14.props.searchType
		local v325 = searchType == SearchTypes.Auto

		if searchType == SearchTypes.Games or v325 then
			search(p14.props.eventIngest, "games", "cancel", nil, v325, name)
		elseif searchType == SearchTypes.TopResults then
			search(p14.props.eventIngest, SearchTypes.TopResults, "cancel", nil, nil, name)
		elseif searchType == SearchTypes.Players then
			search(p14.props.eventIngest, "players", "cancel", nil, nil, name)
		elseif searchType == SearchTypes.Catalog then
			p14.props.analytics.reportSearchCanceled("catalog")
		end

		p14.onExitSearch()
	end
	function p14.cancelSearchAndEndSession() -- line: 400
		-- upvalues: p14 (copy), SessionType (copy)
		p14.cancelSearchCallback()

		if p14.props.sessionService:SessionExists(SessionType.StructuralIdentifier.GameSearchAutocomplete) then
			p14.props.sessionService:RemoveSession(SessionType.StructuralIdentifier.GameSearchAutocomplete)
		end
	end
	function p14.onSearchBarFocused() -- line: 408
		-- upvalues: p14 (copy), SearchTypes (copy), SessionType (copy), search (copy), name (copy)
		if not p14.isMounted then
			return
		end

		local searchType = p14.props.searchType
		local v327 = searchType == SearchTypes.Auto

		if searchType == SearchTypes.Games or v327 or searchType == SearchTypes.TopResults then
			if p14.props.enableSearchAutoComplete then
				p14.props.sessionService:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.GameSearchAutocomplete, SessionType.StructuralIdentifier.GameSearchAutocomplete)
			end

			search(p14.props.eventIngest, searchType ~= SearchTypes.TopResults and "games" or SearchTypes.TopResults, "open", nil, v327, name)
		elseif searchType == SearchTypes.Players then
			search(p14.props.eventIngest, "players", "open", nil, nil, name)
		elseif searchType == SearchTypes.Catalog then
			p14.props.analytics.reportSearchFocused("catalog")
		end

		p14:setIsSearching(true)
	end
	function p14.onTextCleared() -- line: 442
		-- upvalues: p14 (copy)
		if not p14.isMounted then
			return
		end
	end
	function p14.confirmSearchCallback(p15, p16, p17) -- line: 448
		-- upvalues: p14 (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), DiscoveryUtils (copy), SearchTypes (copy)
		if not p14.isMounted then
			return
		end

		local searchType = p14.props.searchType
		local t1 = {
			isAutocompleteSuggestion = p16,
			allAutocompleteSuggestions = p17,
			searchType = searchType,
			isAvatarAutocompleteEnabled = GetFFlagAvatarAutocompleteEnabledForAll(),
			navigation = p14.props.navigation,
			pageOwner = p14:getPageOwner(),
			sessionService = p14.props.sessionService,
			eventIngest = p14.props.eventIngest,
			topBarAnalytics = p14.props.analytics
		}

		p14.props.confirmSearch(p15, t1)

		if DiscoveryUtils.isSearchTypeInOmniSearch(searchType) or searchType == SearchTypes.Catalog then
			p14.onExitSearch()
		end

		if GetFFlagAvatarAutocompleteEnabledForAll() and p14.props.onConfirmSearchCallback then
			p14.props.onConfirmSearchCallback()
		end
	end
	function p14.absolutePositionChangedCallback(p18) -- line: 476
		-- upvalues: p14 (copy)
		p14:setState({
			absolutePosition = p18.AbsolutePosition
		})
	end
	function p14.searchSignalCallback(p19) -- line: 482
		-- upvalues: p14 (copy)
		if p19 == p14:getPageOwner() then
			p14.onSearchButtonActivated()
		end
	end
	function p14.renderNavigation(p20) -- line: 488
		-- upvalues: FFlagEnableAppNavGamepadRemoval (copy), p14 (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy)
		local v336 = if not FFlagEnableAppNavGamepadRemoval then p14:shouldShowCenterItem() and p14.centerItemRef or (p14:getFirstRightItemRef() or p14.props.NextSelectionRight) else nil

		return p14:renderTopBarItem(p14.props.leftItem, nil, v336, nil, nil, if not FFlagLuaAppMoveProfileIntoTopBar and (not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo) then nil else p20, if not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo then nil else p14.props.navigation.state.routeName)
	end
	function p14.renderCenter() -- line: 513
		-- upvalues: p14 (copy), FFlagEnableAppNavGamepadRemoval (copy)
		local v337 = p14:shouldShowLeftItem()
		local centerItem = p14.props.centerItem
		local v339 = if not FFlagEnableAppNavGamepadRemoval then v337 and p14.leftItemRef or nil else nil
		local v340 = if not FFlagEnableAppNavGamepadRemoval then p14:getFirstRightItemRef() or p14.props.NextSelectionRight else nil

		if p14.props.useParentSizeForCenterItem then
			return p14:renderTopBarItem(centerItem, v339, v340, nil, true)
		end

		return p14:renderTopBarItem(centerItem, v339, v340)
	end
end
function v83.isSearchPageOverlayEnabled(p21) -- line: 539
	-- upvalues: v78 (copy), FFlagSearchOmniAutocompletePage (copy), FFlagSearchOmniAutocompletePageIXP (copy)
	if v78 then
		return FFlagSearchOmniAutocompletePage
	end

	return not p21.props.isSpatial and (FFlagSearchOmniAutocompletePage and (not FFlagSearchOmniAutocompletePageIXP or p21.props.shouldShowSearchLandingPage))
end
function v83.setIsSearching(p22, p23) -- line: 549
	p22:setState({
		isSearching = p23
	})

	if p22.props.setDefaultRefOverride then
		local v140 = if not p23 then nil else p22.searchBarRef

		p22.props.setDefaultRefOverride(v140)
	end
end
function v83.didMount(p24) -- line: 559
	p24.isMounted = true
end
function v83.willUnmount(p25) -- line: 563
	p25.isMounted = false
end
function v83.isCompactViewMode(p26) -- line: 567
	-- upvalues: FormFactor (copy)
	local formFactor = p26.props.formFactor

	return p26.props.forceCompactMode or formFactor == FormFactor.COMPACT
end
function v83.getPageNameLocalizationKey(p27) -- line: 575
	-- upvalues: AppPageLocalizationKeys (copy)
	local name = p27.props.currentRoute[1].name

	return AppPageLocalizationKeys[p27.props.navigation.state.routeName] or AppPageLocalizationKeys[name]
end
function v83.maybeRenderRightItems(p28, p29, p30, p31) -- line: 584
	-- upvalues: FFlagEnableAppNavGamepadRemoval (copy)
	if p30 then
		return {}
	end

	if FFlagEnableAppNavGamepadRemoval then
		local rightItems = p28.props.rightItems
		local t2 = {}

		for i, v in ipairs(rightItems) do
			t2["topBarItem_" .. tostring(i)] = p28:renderTopBarItem(v, nil, nil, i)
		end

		return t2
	end

	return p28:renderRightItems(p29, if not p28:shouldShowCenterItem() then if not p31 then nil else p28.leftItemRef else p28.centerItemRef)
end

if not FFlagEnableAppNavGamepadRemoval then
	function v83.renderRightItems(p32, _, p34) -- line: 615
		local rightItems = p32.props.rightItems
		local t3 = {}

		local function nextRef(p35) -- line: 622
			-- upvalues: rightItems (ref), p32 (copy)
			local v342

			repeat
				if not (p35 < #rightItems) then
					return nil
				end

				p35 += 1
				v342 = rightItems[p35]
			until not p32.state.hiddenItems[v342]

			return p32.rightItemRefs[v342]
		end
		local function prevRef(p36) -- line: 634
			-- upvalues: rightItems (ref), p32 (copy)
			local v344

			repeat
				if not (p36 > 1) then
					return nil
				end

				p36 -= 1
				v344 = rightItems[p36]
			until not p32.state.hiddenItems[v344]

			return p32.rightItemRefs[v344]
		end

		for i, v in ipairs(rightItems) do
			local v164 = prevRef(i) or p34
			local v165 = nextRef(i)

			t3["topBarItem_" .. tostring(i)] = p32:renderTopBarItem(v, v164, v165, i)
		end

		return t3
	end
end

function v83.renderTopBarItem(t4: {[any]: any}, p37, p38, p39, n2: number?, b1: boolean?, s1: string?, s2: string?) -- line: 656
	-- upvalues: FFlagEnableAppNavGamepadRemoval (copy), Roact (copy), Focusable (copy), GetFFlagLuaAppFixAppNavHeaderIconsAlignment (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy)
	local formFactor = t4.props.formFactor
	local isSearching = t4.state.isSearching
	local isSecondary = t4.props.isSecondary
	local v177 = t4:isCompactViewMode()
	local v178 = if not FFlagEnableAppNavGamepadRemoval then t4:getItemRef(p37) else nil
	local v179 = if not FFlagEnableAppNavGamepadRemoval then t4:getItemDefaultChildRef(p37) else nil
	local v180 = t4.state.hiddenItems[p37]

	return Roact.createElement(if not FFlagEnableAppNavGamepadRemoval then Focusable.Frame else "Frame", {
		AutomaticSize = if b1 then nil else if not GetFFlagLuaAppFixAppNavHeaderIconsAlignment() then Enum.AutomaticSize.X else Enum.AutomaticSize.XY,
		Size = if b1 then UDim2.fromScale(1, 1) else if not GetFFlagLuaAppFixAppNavHeaderIconsAlignment() then UDim2.fromScale(0, 1) else UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = n2,
		NextSelectionLeft = if not FFlagEnableAppNavGamepadRemoval then p38 else nil,
		NextSelectionRight = if not FFlagEnableAppNavGamepadRemoval then p39 else nil,
		[Roact.Ref] = if not FFlagEnableAppNavGamepadRemoval then v178 else nil,
		defaultChild = v179,
		Visible = not v180
	}, {
		Button = Roact.createElement(p37, {
			formFactor = formFactor,
			isCompactView = v177,
			isSearching = isSearching,
			isSecondary = isSecondary,
			cancelSearch = t4.cancelSearchAndEndSession,
			activateSearch = t4.onSearchButtonActivated,
			setVisible = t4:getButtonVisibilityCallback(p37),
			buttonRef = v179,
			titleText = if not FFlagLuaAppMoveProfileIntoTopBar and (not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo) then nil else s1,
			routeName = if not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo then nil else s2
		})
	})
end
function v83.shouldShowLeftItem(p40) -- line: 709
	local leftItem = p40.props.leftItem

	return not not leftItem and (not p40.state.hiddenItems[leftItem] and (not p40.state.isSearching or false))
end
function v83.shouldShowCenterItem(p41) -- line: 714
	local centerItem = p41.props.centerItem

	return not not centerItem and (not p41.state.hiddenItems[centerItem] or false)
end

if not FFlagEnableAppNavGamepadRemoval then
	function v83.getItemRef(p42, p43) -- line: 720
		if p43 == nil then
			return nil
		end

		if p43 == p42.props.leftItem then
			return p42.leftItemRef
		end

		if p43 == p42.props.centerItem then
			return p42.centerItemRef
		end

		return p42.rightItemRefs[p43]
	end
	function v83.getItemDefaultChildRef(p44, p45) -- line: 727
		if p45 == nil then
			return nil
		end

		return p44.itemDefaultChildRefs[p45]
	end
end

function v83.hasSearchButton(p46) -- line: 732
	-- upvalues: SearchButton (copy)
	local rightItems = p46.props.rightItems

	for _, v in ipairs(rightItems) do
		if v == SearchButton then
			return true
		end
	end

	return false
end

if not FFlagEnableAppNavGamepadRemoval then
	function v83.getFirstRightItemRef(p47) -- line: 743
		local rightItems = p47.props.rightItems

		for _, v in ipairs(rightItems) do
			if not p47.state.hiddenItems[v] then
				return p47.rightItemRefs[v]
			end
		end

		return nil
	end
end

function v83.getButtonVisibilityCallback(p48, p49) -- line: 754
	-- upvalues: Cryo (copy)
	local v199 = p48.buttonVisibilityCallbacks[p49]

	if not v199 then
		function v199(p50) -- line: 757
			-- upvalues: p48 (copy), Cryo (copy), p49 (copy)
			p48:setState(function(p51) -- line: 758
				-- upvalues: Cryo (copy), p49 (copy), p50 (copy)
				return {
					hiddenItems = Cryo.Dictionary.join(p51.hiddenItems, {
						[p49] = not p50 or Cryo.None
					})
				}
			end)
		end

		p48.buttonVisibilityCallbacks[p49] = v199
	end

	return v199
end
function v83.getRenderSearchBar(p52, p53, p54, p55, p56, p57, p58, p59, _) -- line: 771
	-- upvalues: Roact (copy), SearchBar (copy), SearchTypes (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), FFlagEnableAppNavGamepadRemoval (copy), DiscoveryUtils (copy), FFlagSearchOmniAutocompletePage (copy)
	if p53 then
		return function() -- line: 782
			-- upvalues: Roact (copy), SearchBar (copy), p52 (copy), p54 (copy), p55 (copy), p56 (copy), p57 (copy), SearchTypes (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), FFlagEnableAppNavGamepadRemoval (copy), p58 (copy), p59 (copy), DiscoveryUtils (copy), FFlagSearchOmniAutocompletePage (copy)
			local createElement = Roact.createElement
			local v347 = SearchBar
			local t5 = {
				cancelSearch = p52.cancelSearchCallback,
				confirmSearch = p52.confirmSearchCallback,
				onFocused = p52.onSearchBarFocused,
				onTextCleared = p52.onTextCleared,
				isCompactView = p54,
				placeholderText = p55,
				searchType = p56
			}
			local v349 = p57

			if v349 then
				local v350 = p56

				v349 = v350 == SearchTypes.Games or (v350 == SearchTypes.Auto or (v350 == SearchTypes.TopResults or GetFFlagAvatarAutocompleteEnabledForAll() and v350 == SearchTypes.Catalog))
			end

			t5.autocomplete = v349
			t5[Roact.Ref] = p52.searchBarRef
			t5.focusController = if not FFlagEnableAppNavGamepadRemoval then p52.props.focusController else nil
			t5.isSearching = p52.state.isSearching
			t5.animated = p58
			t5.initialSearchText = p52.props.searchParameters and p52.props.searchParameters.searchKeyword or ""
			t5.searchBarPadding = if not p59 then nil else 0
			t5.searchPageOverlayEnabled = if not p52:isSearchPageOverlayEnabled() then nil else DiscoveryUtils.isSearchTypeInOmniSearch(p56)
			t5.disableListPicker = if not p52:isSearchPageOverlayEnabled() then nil else DiscoveryUtils.isSearchTypeInOmniSearch(p56)
			t5.onExitSearch = if not FFlagSearchOmniAutocompletePage then nil else p52.onExitSearch

			return createElement(v347, t5)
		end
	end

	return nil
end
function v83.getRenderRootSearchBar(p61, p62, p63, p64, p65, p66, p67, _) -- line: 811
	-- upvalues: Roact (copy), SearchBar (copy), NON_COMPACT_SEARCH_BAR_SIZE (copy), SearchTypes (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), DiscoveryUtils (copy)
	if not p62 and (p63 and not p64) then
		return function() -- line: 821
			-- upvalues: Roact (copy), SearchBar (copy), NON_COMPACT_SEARCH_BAR_SIZE (copy), p61 (copy), p65 (copy), p64 (copy), p66 (copy), p67 (copy), SearchTypes (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), DiscoveryUtils (copy)
			local createElement = Roact.createElement
			local v352 = SearchBar
			local t6 = {
				Size = UDim2.new(0, NON_COMPACT_SEARCH_BAR_SIZE, 1, 0),
				cancelSearch = p61.cancelSearchCallback,
				confirmSearch = p61.confirmSearchCallback,
				onFocused = p61.onSearchBarFocused,
				onTextCleared = p61.onTextCleared,
				placeholderText = p65,
				isCompactView = p64,
				modernUI = true,
				searchType = p66
			}
			local v354 = p67

			if v354 then
				local v355 = p66

				v354 = v355 == SearchTypes.Games or (v355 == SearchTypes.Auto or (v355 == SearchTypes.TopResults or GetFFlagAvatarAutocompleteEnabledForAll() and v355 == SearchTypes.Catalog))
			end

			t6.autocomplete = v354
			t6.isSearching = p61.state.isSearching
			t6.initialSearchText = p61.props.searchParameters and p61.props.searchParameters.searchKeyword or ""
			t6[Roact.Ref] = p61.searchBarRef
			t6.searchPageOverlayEnabled = if not p61:isSearchPageOverlayEnabled() then nil else DiscoveryUtils.isSearchTypeInOmniSearch(p66)
			t6.disableListPicker = if not p61:isSearchPageOverlayEnabled() then nil else DiscoveryUtils.isSearchTypeInOmniSearch(p66)

			return createElement(v352, t6)
		end
	end

	return nil
end
function v83.renderAppHeaderBar(p69, p70, p71, p72, p73, p74, p75, p76) -- line: 848
	-- upvalues: NAV_BAR_SIZE (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), FFlagLuaAppMoveProfileIntoTopBarIXP (copy), VerticalEfficiencyExperimentation (copy), shouldShowProfileInHeaderBar (copy), shouldShowLeftHeader (ref), Roact (copy), LayoutConfig (copy), FFlagEnableHeaderBarButtonsUpdate (copy), FFlagLuaAppCompositionTopBarFullBleed (copy), AppHeaderBar (copy)
	local Tokens = p71.Tokens
	local t7 = {}
	local tokens = p69.props.tokens

	t7.barHeight = NAV_BAR_SIZE * tokens.Config.UI.Scale

	local v228 = if not FFlagLuaAppMoveProfileIntoTopBar and (not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo) then p69.renderNavigation else function() -- line: 864
		-- upvalues: p69 (copy), p74 (copy), p70 (copy)
		return p69.renderNavigation(p74 or p70.pageTitle)
	end

	t7.renderNavigation = if not p76 then nil else v228

	local centerItem = p69.props.centerItem

	t7.title = p74 or p70.pageTitle
	t7.isTitleCentered = not not p76 and (not p69.props.isSecondary or false)
	t7.titleFontStyle = if not p76 and not p69.props.isSecondary then Tokens.Typography.HeadingLarge else Tokens.Typography.HeadingSmall

	if centerItem then
		t7.title = ""
	elseif p69.state.isSearching then
		t7.title = ""
	elseif FFlagLuaAppMoveProfileIntoTopBar and ((not FFlagLuaAppMoveProfileIntoTopBarIXP or VerticalEfficiencyExperimentation.getIsProfileMovedToTopBar()) and p76 and shouldShowProfileInHeaderBar(p69.props.currentRoute[1].name, p69.props.currentRoute[#p69.props.currentRoute].name, p69.props.formFactor, p69.state.isSearching)) then
		t7.title = ""
	elseif (FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo) and p76 and shouldShowLeftHeader(p69.props.navigation.state.routeName, p69.props.currentRoute[#p69.props.currentRoute].name, p69.state.isSearching) then
		t7.title = ""
	end

	t7.shouldRenderTitle = true
	t7.shouldRenderCenter = true

	if p72 or p73 then
		t7.renderCenter = p72 or p73
	elseif centerItem then
		t7.renderCenter = p69.renderCenter
	end

	t7.renderUtilities = not p72 and function() -- line: 916
		-- upvalues: Roact (copy), p75 (copy)
		return Roact.createFragment(p75)
	end or nil

	local gridConfig = p69.props.gridConfig
	local uDim = UDim.new(0, p69.props.sideMarginOverride or gridConfig[LayoutConfig.Keys.PaddingHorizontal])
	local uDim2 = UDim.new(0, gridConfig[LayoutConfig.Keys.PaddingRightItems])

	t7.utilitiesGap = if not FFlagEnableHeaderBarButtonsUpdate then uDim2 else UDim.new(0, p69.props.tokens.Size.Size_100)
	t7.paddingLeft = uDim
	t7.paddingRight = if not FFlagEnableHeaderBarButtonsUpdate then uDim else uDim - UDim.new(0, p69.props.tokens.Size.Size_100)
	t7.paddingTop = UDim.new(0, 0)
	t7.paddingBottom = UDim.new(0, 0)
	t7.backgroundStyle = if not p69.props.transparentBackground then nil else {
		Transparency = 1,
		Color3 = Color3.new(0, 0, 0)
	}
	t7.onMedia = false
	t7.tag = if not FFlagLuaAppCompositionTopBarFullBleed then nil else p69.props.tag

	return Roact.createElement(AppHeaderBar, t7)
end
function v83.renderWithProviders(p77, p78, p79, p80) -- line: 945
	-- upvalues: LayoutConfig (copy), NAV_BAR_SIZE (copy), SearchTypes (copy), FFlagEnableAppNavGamepadRemoval (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), VisibilityControl (copy), FFlagAppIaStatusBar (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), Roact (copy), React (copy), FFlagLuaAppCompositionTopBarFullBleed (copy), Focusable (copy), ExternalEventConnection (copy), UserInputService (copy), SignalConnection (copy)
	local titleText = p77.props.titleText
	local v238 = p77:shouldShowLeftItem()
	local v239 = p77:hasSearchButton() and p77.props.enableSearch
	local searchType = p77.props.searchType
	local enableSearchAutoComplete = p77.props.enableSearchAutoComplete
	local propsZIndex = p77.props.ZIndex
	local v243 = p77.props.gridConfig[LayoutConfig.Keys.PaddingVertical]
	local statusBarHeight = p77.props.statusBarHeight
	local tokens = p77.props.tokens
	local v246 = statusBarHeight + NAV_BAR_SIZE * tokens.Config.UI.Scale + v243
	local v247 = v246 + p77.props.totalBannerHeight
	local v248 = p77:isCompactViewMode()
	local searchPlaceholderSearchGames = p80.searchPlaceholderSearchGames

	if searchType == SearchTypes.Catalog then
		searchPlaceholderSearchGames = p80.searchPlaceholderSearchMarketplace
	end

	local v250 = v248 and (p77.state.isSearching or p77.props.showSearchBar)
	local showSearchBar = p77.props.showSearchBar
	local v252 = p77:maybeRenderRightItems(p79, v250, v238)
	local v253 = p77:getRenderSearchBar(v250, v248, searchPlaceholderSearchGames, searchType, enableSearchAutoComplete, not showSearchBar, v238)
	local v254 = p77:getRenderRootSearchBar(v250, v239, v248, searchPlaceholderSearchGames, searchType, enableSearchAutoComplete)
	local t8 = {
		Active = true,
		BorderSizePixel = 0,
		ZIndex = 2,
		BackgroundColor3 = p79.Theme.BackgroundDefault.Color,
		BackgroundTransparency = if not p77.props.transparentBackground then p79.Theme.BackgroundDefault.Transparency else 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, v246)
	}
	local uDim2 = UDim2.new(0, p77.props.screenSize.X, 0, p77.props.screenSize.Y)
	local uDim2_2 = UDim2.new(0, -p77.state.absolutePosition.X, 0, -p77.state.absolutePosition.Y)
	local forwardRef = p77.props.forwardRef
	local v259 = if not FFlagEnableAppNavGamepadRemoval then if not v254 and (not v248 or not p77.state.isSearching) then if not p77:shouldShowLeftItem() then if not p77:shouldShowCenterItem() then p77:getFirstRightItemRef() else p77.centerItemRef else p77.leftItemRef else p77.searchBarRef else nil
	local v260 = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then nil else VisibilityControl.getHeaderBinding():map(function(n3: number) -- line: 1024
		-- upvalues: FFlagAppIaStatusBar (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), v247 (copy), statusBarHeight (copy)
		local v357 = if not FFlagAppIaStatusBar or (not FFlagAppIaHomeSubTab or not FlyoutSidePanelIXP.isHomeSubTabEnabled()) then (n3 - 1) * v247 else (n3 - 1) * (v247 - statusBarHeight)

		return UDim2.new(0, 0, 0, v357)
	end)
	local createElement = Roact.createElement
	local t9 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = propsZIndex,
		[React.Tag] = if not FFlagLuaAppCompositionTopBarFullBleed then p77.props.tag else nil,
		[Roact.Change.AbsolutePosition] = p77.absolutePositionChangedCallback
	}
	local t10 = {}
	local createElement2 = Roact.createElement
	local t11 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v247),
		Position = v260
	}
	local t12 = {}
	local createElement3 = Roact.createElement
	local t13 = {}
	local createElement4 = Roact.createElement
	local v270 = if not FFlagEnableAppNavGamepadRemoval then Focusable.Frame else "Frame"
	local t14 = {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = p79.Theme.BackgroundDefault.Color,
		BackgroundTransparency = if not p77.props.transparentBackground then p79.Theme.BackgroundDefault.Transparency else 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0)
	}
	local new = UDim2.new
	local tokens3 = p77.props.tokens

	t14.Size = new(1, 0, 0, NAV_BAR_SIZE * tokens3.Config.UI.Scale)
	t14[Roact.Ref] = forwardRef
	t14.NextSelectionRight = if not FFlagEnableAppNavGamepadRemoval then not (not not v248 and p77.state.isSearching) and p77.props.NextSelectionRight or nil else nil
	t14.NextSelectionDown = if not FFlagEnableAppNavGamepadRemoval then not (not not v248 and p77.state.isSearching) and p77.props.NextSelectionDown or nil else nil
	t14.defaultChild = v259
	t13.NavBar = createElement4(v270, t14, {
		AppHeaderBar = p77:renderAppHeaderBar(p80, p79, v253, v254, titleText, v252, v238)
	})
	t12.TopBar = createElement3("Frame", t8, t13)
	t12.BannerContainer = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.new(0, 0, 0, v246)
	}, p77.props.bannerContainer)
	t10.TopBarContents = createElement2("Frame", t11, t12)
	t10.DarkOverlay = Roact.createElement("TextButton", {
		Size = uDim2,
		Position = uDim2_2,
		AutoButtonColor = false,
		BackgroundColor3 = p79.Theme.Overlay.Color,
		BackgroundTransparency = 1,
		Text = "",
		Visible = p77.state.isSearching,
		[Roact.Event.Activated] = p77.cancelSearchAndEndSession,
		ZIndex = 1
	})
	t10.LastInputChangedListener = if not FFlagEnableAppNavGamepadRemoval then Roact.createElement(ExternalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = function(p81) -- line: 1097
			-- upvalues: p77 (copy)
			p77:setState({
				lastInputType = p81
			})
		end
	}) else nil
	t10.SignalConnection = Roact.createElement(SignalConnection, {
		signal = p78,
		callback = p77.searchSignalCallback
	})
	t10.HiddenItems = p77:renderHiddenItems()

	return createElement("Frame", t9, t10)
end
function v83.renderHiddenItems(p82) -- line: 1113
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		Visible = false
	}, {
		leftItem = p82.props.leftItem and (not p82:shouldShowLeftItem() and p82:renderTopBarItem(p82.props.leftItem)),
		centerItem = p82.props.centerItem and (not p82:shouldShowCenterItem() and p82:renderTopBarItem(p82.props.centerItem))
	})
end
function v83.render(p83) -- line: 1124
	-- upvalues: withTopBarSearchSignal (copy), withStyle (copy), withLocalization (copy)
	return withTopBarSearchSignal(function(p84) -- line: 1125
		-- upvalues: withStyle (copy), p83 (copy), withLocalization (copy)
		return withStyle(function(p85) -- line: 1126
			-- upvalues: p83 (copy), withLocalization (copy), p84 (copy)
			local v367 = p83:getPageNameLocalizationKey()

			return withLocalization({
				searchPlaceholderSearchGames = "Search.GlobalSearch.Example.SearchGames",
				searchPlaceholderSearchMarketplace = "Search.GlobalSearch.Example.SearchMarketplace",
				pageTitle = v367
			})(function(p86) -- line: 1132
				-- upvalues: p83 (copy), p84 (copy), p85 (copy)
				return p83:renderWithProviders(p84, p85, p86)
			end)
		end)
	end)
end
function v83.didUpdate(p87, p88, p89) -- line: 1139
	-- upvalues: FFlagEnableAppNavGamepadRemoval (copy), v82 (copy)
	p87:updateTopBarHeight(p88, p89)

	if not FFlagEnableAppNavGamepadRemoval then
		local v279 = v82[p87.state.lastInputType]
		local focusController = p87.props.focusController

		if p87.state.isSearching and not p89.isSearching and v279 and focusController then
			focusController.moveFocusTo(p87.searchBarRef)
		elseif not p87.state.isSearching and p89.isSearching and v279 and focusController then
			focusController.moveFocusTo(p87.searchButtonRef)
		end
	end

	p87:closeSearchBarIfLeavingPage(p88)
end
function v83.closeSearchBarIfLeavingPage(p90, p91) -- line: 1155
	local currentRoute = p90.props.currentRoute
	local currentRoute2 = p91.currentRoute

	if currentRoute[#currentRoute].name ~= currentRoute2[#currentRoute2].name and p90.state.isSearching == true then
		p90.onExitSearch()
	end

	if p90.props.avatarRoute and p91.avatarRoute and p90.props.avatarRoute.opaque.key ~= p91.avatarRoute.opaque.key and p90.state.isSearching == true then
		p90.onExitSearch()
	end
end

local function isInPeekViewFromSearch(p92) -- line: 1176
	-- upvalues: UseGameDetailsPeekView (copy), AppPage (copy)
	local name = p92[#p92].name

	return (UseGameDetailsPeekView() and name == AppPage.GameDetail or name == AppPage.ProfilePlatform) and (#p92 > 1 and p92[#p92 - 1].name == AppPage.SearchPage)
end
local function getShowSearchBar(p93) -- line: 1185
	-- upvalues: AppPage (copy), UseGameDetailsPeekView (copy)
	if p93[#p93].name == AppPage.SearchPage then
		return true
	end

	local name = p93[#p93].name

	if (UseGameDetailsPeekView() and name == AppPage.GameDetail or name == AppPage.ProfilePlatform) and (#p93 > 1 and p93[#p93 - 1].name == AppPage.SearchPage) then
		return true
	end

	return false
end
local function getCurrentOpaquePage(p94) -- line: 1197
	-- upvalues: AppPageProperties (copy)
	for i = #p94, 1, -1 do
		local name = p94[i].name
		local v292 = AppPageProperties[name]

		if v292 == nil or not v292.renderUnderlyingPage then
			return name
		end
	end

	return nil
end

local v91 = wrapComponent(function(p95, p96) -- line: 1209
	-- upvalues: getPageMargin (copy), withGridConfig_DEPRECATED (copy), LayoutConfig (copy), Roact (copy), Cryo (copy)
	local v295 = p96.sideMarginOverride or getPageMargin(p96.screenSize.X)

	return withGridConfig_DEPRECATED({
		[LayoutConfig.Keys.PaddingRightItems] = 0,
		[LayoutConfig.Keys.PaddingHorizontal] = v295,
		[LayoutConfig.Keys.PaddingVertical] = 0
	}, LayoutConfig.Kind)(function(p97) -- line: 1216
		-- upvalues: Roact (copy), p95 (copy), Cryo (copy), p96 (copy)
		return Roact.createElement(p95, Cryo.Dictionary.join(p96, {
			gridConfig = p97
		}))
	end)
end)(v83)
local v92 = RoactRodux.connect(function(p98, _) -- line: 1226
	-- upvalues: FFlagSignalsNavP3bTopBar (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy), UseGameDetailsPeekView (copy), getCurrentOpaquePage (copy)
	local v298 = if not FFlagSignalsNavP3bTopBar then if not FFlagUseNavigationSelectors then p98.Navigation.history[#p98.Navigation.history] else Selectors.selectCurrentLegacyRoute(p98) else nil
	local t15 = {
		screenSize = p98.ScreenSize,
		formFactor = p98.FormFactor,
		currentRoute = v298
	}
	local v300

	if FFlagSignalsNavP3bTopBar then
		v300 = nil
	elseif v298[#v298].name == AppPage.SearchPage then
		v300 = true
	else
		local name = v298[#v298].name

		v300 = not not ((UseGameDetailsPeekView() and name == AppPage.GameDetail or name == AppPage.ProfilePlatform) and (#v298 > 1 and v298[#v298 - 1].name == AppPage.SearchPage))
	end

	t15.showSearchBar = v300
	t15.statusBarHeight = p98.TopBar.statusBarHeight
	t15.opaquePage = if not FFlagSignalsNavP3bTopBar then getCurrentOpaquePage(v298) else nil

	return t15
end, function(p100) -- line: 1241
	-- upvalues: ConfirmSearch (copy), SetTopBarHeight (copy)
	return {
		confirmSearch = function(p101, p102) -- line: 1243
			-- upvalues: p100 (copy), ConfirmSearch (copy)
			return p100(ConfirmSearch(p101, p102))
		end,
		setTopBarHeight = function(p103) -- line: 1246
			-- upvalues: p100 (copy), SetTopBarHeight (copy)
			return p100(SetTopBarHeight(p103))
		end
	}
end)(v91)

if FFlagSignalsNavP3bTopBar then
	local v93 = v92

	function v92(p104) -- line: 1255
		-- upvalues: v74 (copy), useSignalState (copy), React (copy), v93 (copy), Cryo (copy), AppPage (copy), UseGameDetailsPeekView (copy), getCurrentOpaquePage (copy)
		local v304 = v74(false)
		local v305 = useSignalState(v304.getCurrentLegacyRoute)
		local createElement = React.createElement
		local v307 = v93
		local union = Cryo.Dictionary.union
		local t16 = {
			currentRoute = v305
		}
		local v310

		if v305[#v305].name == AppPage.SearchPage then
			v310 = true
		else
			local name = v305[#v305].name

			v310 = not not ((UseGameDetailsPeekView() and name == AppPage.GameDetail or name == AppPage.ProfilePlatform) and (#v305 > 1 and v305[#v305 - 1].name == AppPage.SearchPage))
		end

		t16.showSearchBar = v310
		t16.opaquePage = getCurrentOpaquePage(v305)

		return createElement(v307, union(p104, t16))
	end
end

local v94 = RoactServices.connect({
	analytics = RoactAnalyticsTopBar,
	sessionService = AppSessionService,
	eventIngest = AppEventIngestService
})(v92)
local v95 = RoactAppPolicy.connect(function(p105, _) -- line: 1275
	return {
		enableNotifications = p105.getNotifications(),
		enableSearch = p105.getSearchBar(),
		enableSearchAutoComplete = p105.getSearchAutoComplete()
	}
end)(v94)
local v96 = withAvatarRoute(RoactNavigation.withNavigation(v95), {
	required = false
})

if not v78 and FFlagSearchOmniAutocompletePageIXP then
	v96 = RoactAppExperiment.connectUserLayer({ v64 }, function(p107, _) -- line: 1289
		-- upvalues: v64 (copy)
		return {
			shouldShowSearchLandingPage = (p107[v64] or {}).shouldShowSearchLandingPage
		}
	end, false)(v96)
end

local v97 = v96

local function u98(p109) -- line: 1299
	-- upvalues: useBannerContainer (copy), useIsSpatial (copy), useTokens (copy), FFlagEnableAppNavGamepadRemoval (copy), Roact (copy), v97 (copy), Cryo (copy), RoactGamepad (copy)
	local hideSiteMessageBanner = p109.hideSiteMessageBanner
	local v318, v319 = useBannerContainer(hideSiteMessageBanner)
	local v320 = useIsSpatial()
	local v321 = useTokens()

	if FFlagEnableAppNavGamepadRemoval then
		return Roact.createElement(v97, Cryo.Dictionary.join(p109, {
			bannerContainer = v318,
			totalBannerHeight = v319,
			isSpatial = v320,
			tokens = v321
		}))
	end

	return RoactGamepad.withFocusController(function(p110) -- line: 1317
		-- upvalues: Roact (copy), v97 (copy), Cryo (copy), p109 (copy), v318 (copy), v319 (copy), v320 (copy), v321 (copy)
		return Roact.createElement(v97, Cryo.Dictionary.join(p109, {
			focusController = p110,
			bannerContainer = v318,
			totalBannerHeight = v319,
			isSpatial = v320,
			tokens = v321
		}))
	end)
end

return Roact.forwardRef(function(p111, p112) -- line: 1332
	-- upvalues: Roact (copy), u98 (ref), Cryo (copy)
	return Roact.createElement(u98, Cryo.Dictionary.join(p111, {
		forwardRef = p112
	}))
end)
