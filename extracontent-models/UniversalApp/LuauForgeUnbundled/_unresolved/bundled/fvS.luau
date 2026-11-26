local CorePackages = game:GetService("CorePackages")

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
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module = require("@luauforge/bundled/fvT")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local module2 = require("@luauforge/bundled/ecr")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local verticalEfficiencyExperimentation = require("@luauforge/bundled/egz").VerticalEfficiencyExperimentation
local module3 = require("@luauforge/bundled/egz")
local searchConstants = require("@luauforge/bundled/dtb").Modules.Personalization.Search.SearchConstants
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectors = NavigationRodux.Selectors

local module5 = require("@luauforge/bundled/fvZ")
local module6 = require("@luauforge/bundled/dFu")
local module7 = require("@luauforge/bundled/dGJ")

local module8 = require("@luauforge/bundled/dzA")

local module9 = require("@luauforge/bundled/dXA")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module10 = require("@luauforge/bundled/dzD")
local module11 = require("@luauforge/bundled/fwT")
local module12 = require("@luauforge/bundled/fwU")
local sessionType = require("@luauforge/bundled/fwa").SessionType
local module13 = require("@luauforge/bundled/fvU")
local module14 = require("@luauforge/bundled/fyN")
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local module16 = require("@luauforge/bundled/fyO")
local module17 = require("@luauforge/bundled/fAa")
local module18 = require("@luauforge/bundled/fAb")
local module19 = require("@luauforge/bundled/fAd")
local module20 = require("@luauforge/bundled/fAe")
local module21 = require("@luauforge/bundled/fAh")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local module22 = require("@luauforge/bundled/fAi")
local module23 = require("@luauforge/bundled/fAj")
local layoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LayoutConfig
local appHeaderBar = require("@luauforge/bundled/fAk").AppHeaderBar
local module24 = require("@luauforge/bundled/dKz")
local visibilityControl = module24.VisibilityControl

local module25 = require("@luauforge/bundled/fyM")

local fFlagLuaAppSduiSearchAutocomplete = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiSearchAutocomplete

local getFFlagLuaAppFixAppNavHeaderIconsAlignment = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppFixAppNavHeaderIconsAlignment

local fFlagLuaAppMoveProfileIntoTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBar

local fFlagLuaAppMoveProfileIntoTopBarIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBarIXP
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId

local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagAppIaStatusBar = SharedFlags.FFlagAppIaStatusBar
local fFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3bTopBar then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local module27 = require("@luauforge/bundled/dKL")
local fFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP
local fFlagAXMeTabTopScrim = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMeTabTopScrim
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground
local fFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground
local module28 = require("@luauforge/bundled/fAl")

local v5 = if module28 then require("@luauforge/bundled/ehR") else nil

local fFlagAXSearchAndCancelLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSearchAndCancelLogging
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local shouldShowLeftHeader

if module27 or fFlagEnableHomeRobloxLogo then
	shouldShowLeftHeader = require("@luauforge/bundled/fAm").Utils.shouldShowLeftHeader
else
	shouldShowLeftHeader = nil
end

local NAV_BAR_SIZE = module10.NAV_BAR_SIZE

local NON_COMPACT_SEARCH_BAR_SIZE = searchConstants.NON_COMPACT_SEARCH_BAR_SIZE

local extended = Roact.Component:extend("TopBarContainer")

local strictInterface = t.strictInterface
local v6 = {}

v6.searchType = t.string
v6.ZIndex = t.number
v6.hideSiteMessageBanner = t.boolean
v6.forceCompactMode = t.boolean
v6.transparentBackground = t.boolean

local v7 = if fFlagAppThemeHalloween2026HomeBackground or module28 then t.optional(t.table) else nil
v6.backgroundSlot = v7

local v8 = if fFlagEnableClassicThemeHeaderBackground then t.optional(t.boolean) else nil
v6.enableHeaderImageBackground = v8
v6.searchParameters = t.optional(t.table)
v6.onConfirmSearchCallback = t.optional(t.callback)
v6.titleText = t.optional(t.string)
v6.NextSelectionUp = t.optional(t.table)
v6.NextSelectionDown = t.optional(t.table)
v6.NextSelectionLeft = t.optional(t.table)
v6.NextSelectionRight = t.optional(t.table)
v6.leftItem = t.optional(t.any)
v6.centerItem = t.optional(t.any)
v6.rightItems = t.optional(t.array(t.any))
v6.isSecondary = t.optional(t.boolean)
v6.useParentSizeForCenterItem = t.optional(t.boolean)

local v9 = if fFlagAXMeTabTopScrim then t.optional(t.boolean) else nil
v6.showTopScrim = v9

v6.setDefaultRefOverride = t.optional(t.callback)

v6.gridConfig = t.optional(t.table)

v6.totalBannerHeight = t.optional(t.number)
v6.bannerContainer = t.optional(t.table)
v6.isSpatial = t.optional(t.boolean)

v6.screenSize = t.Vector2
v6.formFactor = t.string
v6.currentRoute = t.table
v6.showSearchBar = t.boolean
v6.statusBarHeight = t.number
v6.opaquePage = t.optional(t.string)

v6.confirmSearch = t.callback
v6.setTopBarHeight = t.callback

v6.analytics = t.table
v6.sessionService = t.optional(t.union(t.Instance, t.table))
v6.eventIngest = t.table

v6.enableNotifications = t.boolean
v6.enableSearch = t.boolean
v6.enableSearchAutoComplete = t.boolean

v6.navigation = t.table

v6.avatarRoute = t.optional(t.table)

v6.forwardRef = t.optional(t.table)

v6.shouldNavigateToSearchLandingPage = t.optional(t.boolean)

v6.sideMarginOverride = t.optional(t.number)

v6.tag = t.optional(t.string)

v6.tokens = t.table
extended.validateProps = strictInterface(v6)

extended.defaultProps = {
	searchType = searchTypes.Games,
	enableSearch = false,
	ZIndex = 2,
	onConfirmSearchCallback = nil,
	hideSiteMessageBanner = false,
	forceCompactMode = false,
	transparentBackground = false,
	enableHeaderImageBackground = if fFlagEnableClassicThemeHeaderBackground then false else nil,
	rightItems = {}
}

local function applyTokenScaling(p2, p3)
	return p2 * p3.Config.UI.Scale
end

local function calculateNavBarSize(p2)
	return NAV_BAR_SIZE * p2.Config.UI.Scale
end

local function calculateTopBarHeight(data, p2)
	return data.statusBarHeight + NAV_BAR_SIZE * data.tokens.Config.UI.Scale + math.round(data.totalBannerHeight) + 2 * data.gridConfig[layoutConfig.Keys.PaddingVertical]
end

function extended.shouldUpdate(p2, p3, p4): boolean
	if p4 ~= p2.state then
		return true
	end

	if p3 == p2.props then
		return false
	end

	for k, v12 in pairs(p3) do
		if k ~= "rightItems" and p2.props[k] ~= v12 then
			return true
		end
	end

	for k, v12 in pairs(p2.props) do
		if k ~= "rightItems" and p3[k] ~= v12 then
			return true
		end
	end

	return not Dash.shallowEqual(p2.props.rightItems, p3.rightItems)
end

function extended:getPageOwner()
	return self.props.navigation.state.routeName
end

local function isTopPage(data): boolean
	local currentRoute = data.currentRoute
	local name = currentRoute[#currentRoute].name

	local v12 = if data.avatarRoute then data.avatarRoute.opaque.name else data.opaquePage

	local routeName = data.navigation.state.routeName

	if fFlagAppIaHomeSubTab and routeName == NavigationRodux.Constants.HomeContainerName then
		return Cryo.List.find(module24.Constants.HOME_CONTAINER_SUB_TAB_PAGES, name) ~= nil
	end

	return routeName == name or routeName == v12
end

function extended:updateTopBarHeight(data, p3)
	local props = self.props
	local state = self.state
	local v12 = props.statusBarHeight + NAV_BAR_SIZE * props.tokens.Config.UI.Scale + math.round(props.totalBannerHeight) + 2 * props.gridConfig[layoutConfig.Keys.PaddingVertical]

	local topPage = isTopPage(self.props)

	if data and p3 and data.navigation == self.props.navigation then
		local v13 = data.statusBarHeight + NAV_BAR_SIZE * data.tokens.Config.UI.Scale + math.round(data.totalBannerHeight) + 2 * data.gridConfig[layoutConfig.Keys.PaddingVertical]

		local topPage2 = isTopPage(data)

		if v13 == v12 and topPage == topPage2 then
			return
		end
	end

	if topPage then
		module9.GetDisplayStore().setTopBarHeight(v12)
		self.props.setTopBarHeight(v12)

		if fFlagAppIaScrollAway and module24.getScrollAwayEnabled() then
			visibilityControl.setScrollDistance(v12)
		end
	end
end

function extended:init()
	self.searchBarRef = Roact.createRef()

	self.isMounted = false

	self.buttonVisibilityCallbacks = {}

	self.state = {
		isSearching = false,
		absolutePosition = Vector2.new(0, 0),
		hiddenItems = {}
	}

	self:bindFunctions()

	self:updateTopBarHeight()
end

function extended:bindFunctions()
	local currentRoute = self.props.currentRoute
	local name = currentRoute[#currentRoute].name

	function self.onSearchButtonActivated()
		if not self.isMounted then
			return
		end

		if fFlagAXSearchAndCancelLogging then
			self:setIsSearching(true)
			self.props.analytics.reportSearchButtonClick(name)

			if self.props.shouldNavigateToSearchLandingPage then
				sendUnifiedEventLog({
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					elementName = unifiedLoggingElementNameEnums.CATALOG_SEARCH_BUTTON,
					surface = unifiedLoggingSurface.CATALOG
				})

				self:setIsSearching(false)
				self.props.navigation.navigate(avatarScreen.CatalogSearchLanding)
			end
		else
			self:setIsSearching(true)
			self.props.analytics.reportSearchButtonClick(name)

			if self.props.shouldNavigateToSearchLandingPage then
				self:setIsSearching(false)
				self.props.navigation.navigate(avatarScreen.CatalogSearchLanding)
			end
		end
	end

	function self.onExitSearch()
		if not self.isMounted then
			return
		end

		self:setIsSearching(false)
	end

	function self.cancelSearchCallback()
		if not self.isMounted then
			return
		end

		local searchType = self.props.searchType
		local v12 = searchType == searchTypes.Auto

		if searchType == searchTypes.Games or v12 then
			module13(self.props.eventIngest, "games", "cancel", nil, v12, name)
		elseif searchType == searchTypes.TopResults then
			module13(self.props.eventIngest, searchTypes.TopResults, "cancel", nil, nil, name)
		elseif searchType == searchTypes.Players then
			module13(self.props.eventIngest, "players", "cancel", nil, nil, name)
		elseif searchType == searchTypes.Catalog then
			self.props.analytics.reportSearchCanceled("catalog")
		end

		self.onExitSearch()
	end

	function self.cancelSearchAndEndSession()
		self.cancelSearchCallback()

		if self.props.sessionService:SessionExists(sessionType.StructuralIdentifier.GameSearchAutocomplete) then
			self.props.sessionService:RemoveSession(sessionType.StructuralIdentifier.GameSearchAutocomplete)
		end
	end

	function self.onSearchBarFocused()
		if not self.isMounted then
			return
		end

		local searchType = self.props.searchType
		local v12 = searchType == searchTypes.Auto

		if searchType == searchTypes.Games or v12 or searchType == searchTypes.TopResults then
			if self.props.enableSearchAutoComplete then
				self.props.sessionService:SetSession(
					sessionType.StructuralIdentifier.Level1,
					sessionType.StructuralIdentifier.GameSearchAutocomplete,
					sessionType.StructuralIdentifier.GameSearchAutocomplete
				)
			end

			module13(
				self.props.eventIngest,
				searchType ~= searchTypes.TopResults and "games" or searchTypes.TopResults,
				"open",
				nil,
				v12,
				name
			)
		elseif searchType == searchTypes.Players then
			module13(self.props.eventIngest, "players", "open", nil, nil, name)
		elseif searchType == searchTypes.Catalog then
			self.props.analytics.reportSearchFocused("catalog")
		end

		self:setIsSearching(true)
	end

	function self.onTextCleared()
		if self.isMounted then
		end
	end

	function self.confirmSearchCallback(p2, p3, p4, p5)
		if not self.isMounted then
			return
		end

		local v12 = self.props.searchType
		v12 = fFlagLuaAppSduiSearchAutocomplete and p5 or v12
		local v13 = {
			isAutocompleteSuggestion = p3,
			allAutocompleteSuggestions = p4,
			searchType = v12,
			isAvatarAutocompleteEnabled = module25(),
			navigation = self.props.navigation,
			pageOwner = self:getPageOwner(),
			sessionService = self.props.sessionService,
			eventIngest = self.props.eventIngest,
			topBarAnalytics = self.props.analytics
		}

		self.props.confirmSearch(p2, v13)

		if module3.isSearchTypeInOmniSearch(v12) or v12 == searchTypes.Catalog then
			self.onExitSearch()
		end

		if module25() and self.props.onConfirmSearchCallback then
			self.props.onConfirmSearchCallback()
		end
	end

	function self.absolutePositionChangedCallback(p2)
		self:setState({ absolutePosition = p2.AbsolutePosition })
	end

	function self.searchSignalCallback(p2)
		if self:getPageOwner() == p2 then
			self.onSearchButtonActivated()
		end
	end

	function self.renderNavigation(p2)
		local leftItem = self.props.leftItem

		if not (fFlagLuaAppMoveProfileIntoTopBar or module27 or fFlagEnableHomeRobloxLogo) then
			p2 = nil
		end

		local v17 = if module27 or fFlagEnableHomeRobloxLogo then self.props.navigation.state.routeName else nil
		return self:renderTopBarItem(leftItem, nil, nil, nil, nil, p2, v17)
	end

	function self.renderCenter()
		local centerItem = self.props.centerItem

		if self.props.useParentSizeForCenterItem then
			return self:renderTopBarItem(centerItem, nil, nil, nil, true)
		end

		return self:renderTopBarItem(centerItem, nil, nil)
	end
end

function extended:setIsSearching(p2)
	self:setState({ isSearching = p2 })

	if self.props.setDefaultRefOverride then
		local v12 = if p2 then self.searchBarRef else nil
		self.props.setDefaultRefOverride(v12)
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:isCompactViewMode()
	local formFactor2 = self.props.formFactor
	return self.props.forceCompactMode or formFactor2 == formFactor.COMPACT
end

function extended:getPageNameLocalizationKey()
	local name = self.props.currentRoute[1].name

	return module11[self.props.navigation.state.routeName] or module11[name]
end

function extended:maybeRenderRightItems(p2)
	if p2 then
		return {}
	end

	local rightItems = self.props.rightItems
	local result = {}

	for i, rightItem in ipairs(rightItems) do
		result["topBarItem_" .. tostring(i)] = self:renderTopBarItem(rightItem, nil, nil, i)
	end

	return result
end

function extended:renderTopBarItem(p2, p3, p4, layoutOrder, p5, titleText, routeName)
	local formFactor2 = self.props.formFactor
	local isSearching = self.state.isSearching
	local isSecondary = self.props.isSecondary
	local compactViewMode = self:isCompactViewMode()

	local v12 = not self.state.hiddenItems[p2]

	local createElement = Roact.createElement
	local v15

	if not p5 then
		if getFFlagLuaAppFixAppNavHeaderIconsAlignment() then
			v15 = Enum.AutomaticSize.XY
		else
			v15 = Enum.AutomaticSize.X
		end
	end

	local udim

	if p5 then
		udim = UDim2.fromScale(1, 1)
	elseif getFFlagLuaAppFixAppNavHeaderIconsAlignment() then
		udim = UDim2.fromScale(0, 0)
	else
		udim = UDim2.fromScale(0, 1)
	end

	local createElement2 = Roact.createElement
	local v17 = {
		formFactor = formFactor2,
		isCompactView = compactViewMode,
		isSearching = isSearching,
		isSecondary = isSecondary,
		cancelSearch = self.cancelSearchAndEndSession,
		activateSearch = self.onSearchButtonActivated,
		setVisible = self:getButtonVisibilityCallback(p2),
		titleText = 0,
		routeName = 0
	}

	if not (fFlagLuaAppMoveProfileIntoTopBar or module27 or fFlagEnableHomeRobloxLogo) then
		titleText = nil
	end

	v17.titleText = titleText

	if not (module27 or fFlagEnableHomeRobloxLogo) then
		routeName = nil
	end

	v17.routeName = routeName
	return createElement("Frame", {
		AutomaticSize = v15,
		Size = udim,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Visible = v12
	}, { Button = createElement2(p2, v17) })
end

function extended:shouldShowLeftItem(): boolean
	local leftItem = self.props.leftItem
	return if leftItem then not (self.state.hiddenItems[leftItem] or self.state.isSearching) or false else false
end

function extended:shouldShowCenterItem()
	local centerItem = self.props.centerItem
	return centerItem and not self.state.hiddenItems[centerItem] or false
end

function extended:hasSearchButton(): boolean
	local rightItems = self.props.rightItems

	for i, rightItem in ipairs(rightItems) do
		if rightItem == module22 then
			return true
		end
	end

	return false
end

function extended:getButtonVisibilityCallback(p2)
	local buttonVisibilityCallback = self.buttonVisibilityCallbacks[p2]

	if not buttonVisibilityCallback then
		buttonVisibilityCallback = function(p3)
			self:setState(function(p4)
				return {
					hiddenItems = Cryo.Dictionary.join(p4.hiddenItems, {
						[p2] = not p3 or Cryo.None
					})
				}
			end)
		end
		self.buttonVisibilityCallbacks[p2] = buttonVisibilityCallback
	end

	return buttonVisibilityCallback
end

function extended:getRenderSearchBar(p2, p3, p4, p5, p6, animated, p7, p8)
	if p2 then
		return function()
			local createElement = Roact.createElement
			local searchBarRefsByRef = {}
			searchBarRefsByRef.cancelSearch = self.cancelSearchCallback
			searchBarRefsByRef.confirmSearch = self.confirmSearchCallback
			searchBarRefsByRef.onFocused = self.onSearchBarFocused
			searchBarRefsByRef.onTextCleared = self.onTextCleared
			searchBarRefsByRef.isCompactView = p3
			searchBarRefsByRef.placeholderText = p4
			searchBarRefsByRef.searchType = p5
			local v13 = p6

			if v13 then
				local v14 = p5
				v13 = v14 == searchTypes.Games
					or v14 == searchTypes.Auto
					or v14 == searchTypes.TopResults
					or module25() and v14 == searchTypes.Catalog
			end

			searchBarRefsByRef.autocomplete = v13
			searchBarRefsByRef[Roact.Ref] = self.searchBarRef
			searchBarRefsByRef.isSearching = self.state.isSearching
			searchBarRefsByRef.animated = animated
			searchBarRefsByRef.initialSearchText = self.props.searchParameters
				and self.props.searchParameters.searchKeyword
				or ""
			searchBarRefsByRef.searchBarPadding = p7 and 0 or nil
			searchBarRefsByRef.searchPageOverlayEnabled = module3.isSearchTypeInOmniSearch(p5)
			searchBarRefsByRef.disableListPicker = module3.isSearchTypeInOmniSearch(p5)
			searchBarRefsByRef.onExitSearch = self.onExitSearch
			return createElement(module12, searchBarRefsByRef)
		end
	end

	return nil
end

function extended:getRenderRootSearchBar(p2, p3, p4, p5, p6, p7, p8)
	if p2 or not p3 or p4 then
		return nil
	end

	return function()
		local createElement = Roact.createElement
		local searchBarRefsByRef = {
			["Size"] = UDim2.new(0, NON_COMPACT_SEARCH_BAR_SIZE, 1, 0),
			cancelSearch = self.cancelSearchCallback,
			confirmSearch = self.confirmSearchCallback,
			onFocused = self.onSearchBarFocused,
			onTextCleared = self.onTextCleared,
			placeholderText = p5,
			isCompactView = p4,
			modernUI = true,
			searchType = p6
		}

		local v13 = p7

		if v13 then
			local v14 = p6
			v13 = v14 == searchTypes.Games
				or v14 == searchTypes.Auto
				or v14 == searchTypes.TopResults
				or module25() and v14 == searchTypes.Catalog
		end

		searchBarRefsByRef.autocomplete = v13
		searchBarRefsByRef.isSearching = self.state.isSearching
		searchBarRefsByRef.initialSearchText = self.props.searchParameters
			and self.props.searchParameters.searchKeyword
			or ""
		searchBarRefsByRef[Roact.Ref] = self.searchBarRef
		searchBarRefsByRef.searchPageOverlayEnabled = module3.isSearchTypeInOmniSearch(p6)
		searchBarRefsByRef.disableListPicker = module3.isSearchTypeInOmniSearch(p6)
		return createElement(module12, searchBarRefsByRef)
	end
end

function extended:renderAppHeaderBar(p2, p3, p4, p5, p6, p7, p8)
	local tokens = p3.Tokens
	local v12 = {}
	v12.barHeight = NAV_BAR_SIZE * self.props.tokens.Config.UI.Scale

	local fn = (fFlagLuaAppMoveProfileIntoTopBar or module27 or fFlagEnableHomeRobloxLogo) and function()
		return self.renderNavigation(p6 or p2.pageTitle)
	end or self.renderNavigation

	if not p8 then
		fn = nil
	end

	v12.renderNavigation = fn

	local centerItem = self.props.centerItem
	v12.title = p6 or p2.pageTitle
	v12.isTitleCentered = p8 and not self.props.isSecondary and true or false
	local v13 = if p8 or self.props.isSecondary then tokens.Typography.HeadingSmall else tokens.Typography.HeadingLarge
	v12.titleFontStyle = v13

	if centerItem then
		v12.title = ""
	elseif self.state.isSearching then
		v12.title = ""
	elseif
		fFlagLuaAppMoveProfileIntoTopBar
		and (not fFlagLuaAppMoveProfileIntoTopBarIXP or verticalEfficiencyExperimentation.getIsProfileMovedToTopBar())
		and p8
		and module21(
			self.props.currentRoute[1].name,
			self.props.currentRoute[#self.props.currentRoute].name,
			self.props.formFactor,
			self.state.isSearching
		)
	then
		v12.title = ""
	elseif
		(module27 or fFlagEnableHomeRobloxLogo)
		and p8
		and shouldShowLeftHeader(
			self.props.navigation.state.routeName,
			self.props.currentRoute[#self.props.currentRoute].name,
			self.state.isSearching
		)
	then
		v12.title = ""
	end

	v12.shouldRenderTitle = true
	v12.shouldRenderCenter = true

	if p4 or p5 then
		v12.renderCenter = p4 or p5
	elseif centerItem then
		v12.renderCenter = self.renderCenter
	end

	v12.renderUtilities = not p4 and function()
		return Roact.createFragment(p7)
	end or nil

	local gridConfig = self.props.gridConfig

	local udim = UDim.new(
		0,
		self.props.sideMarginOverride or gridConfig[layoutConfig.Keys.PaddingHorizontal]
	)
	local udim2 = UDim.new(0, gridConfig[layoutConfig.Keys.PaddingRightItems])

	if fFlagEnableHeaderBarButtonsUpdate then
		udim2 = UDim.new(0, self.props.tokens.Size.Size_100)
	end

	v12.utilitiesGap = udim2

	v12.paddingLeft = udim

	if fFlagEnableHeaderBarButtonsUpdate then
		udim -= UDim.new(0, self.props.tokens.Size.Size_100)
	end

	v12.paddingRight = udim

	v12.paddingTop = UDim.new(0, 0)
	v12.paddingBottom = UDim.new(0, 0)
	v12.backgroundStyle = self.props.transparentBackground
		and { Color3 = Color3.new(0, 0, 0), Transparency = 1 }
		or nil

	if fFlagEnableClassicThemeHeaderBackground then
		v12.enableHeaderImageBackground = self.props.enableHeaderImageBackground
	end

	v12.onMedia = false
	v12.tag = self.props.tag
	return Roact.createElement(appHeaderBar, v12)
end

function extended:renderWithProviders(p2, p3, p4)
	local titleText = self.props.titleText

	local shouldShowLeftItem = self:shouldShowLeftItem()
	local enableSearch = self:hasSearchButton() and self.props.enableSearch

	local searchType = self.props.searchType

	local enableSearchAutoComplete = self.props.enableSearchAutoComplete

	local zIndex = self.props.ZIndex

	local v12 = self.props.gridConfig[layoutConfig.Keys.PaddingVertical]

	local statusBarHeight = self.props.statusBarHeight
	local v13 = statusBarHeight + NAV_BAR_SIZE * self.props.tokens.Config.UI.Scale + v12

	local v14 = v13 + self.props.totalBannerHeight

	local compactViewMode = self:isCompactViewMode()

	local v15 = p4.searchPlaceholderSearchGames

	if searchType == searchTypes.Catalog then
		v15 = p4.searchPlaceholderSearchMarketplace
	end

	local isSearching = compactViewMode and (self.state.isSearching or self.props.showSearchBar)

	local v16 = not self.props.showSearchBar

	local maybeRenderRightItems = self:maybeRenderRightItems(isSearching)
	local renderSearchBar = self:getRenderSearchBar(
		isSearching,
		compactViewMode,
		v15,
		searchType,
		enableSearchAutoComplete,
		v16,
		shouldShowLeftItem
	)

	local renderRootSearchBar = self:getRenderRootSearchBar(
		isSearching,
		enableSearch,
		compactViewMode,
		v15,
		searchType,
		enableSearchAutoComplete
	)

	local v17 = {
		Active = true,
		BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
		BackgroundTransparency = self.props.transparentBackground and 1 or p3.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, v13),
		ZIndex = 2
	}

	local udim = UDim2.new(0, self.props.screenSize.X, 0, self.props.screenSize.Y)
	local udim2 = UDim2.new(0, -self.state.absolutePosition.X, 0, -self.state.absolutePosition.Y)

	local forwardRef = self.props.forwardRef
	local v18

	if fFlagAppIaScrollAway and module24.getScrollAwayEnabled() then
		v18 = visibilityControl.getHeaderBinding():map(function(p5)
			local v19 = if fFlagAppIaStatusBar and fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled() then (p5 - 1) * (v14 - statusBarHeight) else (p5 - 1) * v14
			return UDim2.new(0, 0, 0, v19)
		end)
	end

	local createElement = Roact.createElement
	local absolutePositionChangedCallbacksByAbsolutePosition = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = zIndex,
		[Roact.Change.AbsolutePosition] = self.absolutePositionChangedCallback
	}

	local createElement2 = Roact.createElement
	local v21 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v14),
		Position = v18
	}

	local createElement3 = Roact.createElement

	local v24 = if fFlagAppThemeHalloween2026HomeBackground or module28 then self.props.backgroundSlot else nil

	local v25 = if fFlagAXMeTabTopScrim and self.props.showTopScrim then Roact.createElement(module23, {
		ZIndex = 0
	}) else nil
	local children = {
		TopBarContents = createElement2("Frame", v21, {
			TopBar = createElement3("Frame", v17, {
				BackgroundSlot = v24,
				Scrim = v25,
				NavBar = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
					BackgroundTransparency = self.props.transparentBackground and 1 or p3.Theme.BackgroundDefault.Transparency,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, NAV_BAR_SIZE * self.props.tokens.Config.UI.Scale),
					[Roact.Ref] = forwardRef
				}, {
					AppHeaderBar = self:renderAppHeaderBar(
						p4,
						p3,
						renderSearchBar,
						renderRootSearchBar,
						titleText,
						maybeRenderRightItems,
						shouldShowLeftItem
					)
				})
			}),
			BannerContainer = Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.new(0, 0, 0, v13),
					BackgroundTransparency = 1
				},
				self.props.bannerContainer
			)
		}),
		DarkOverlay = 0,
		SignalConnection = 0,
		HiddenItems = 0
	}

	local createElement5 = Roact.createElement
	local v27 = {
		["Size"] = nil,
		Size = udim,
		Position = udim2,
		AutoButtonColor = false,
		BackgroundColor3 = p3.Theme.Overlay.Color,
		BackgroundTransparency = 1,
		Text = "",
		Visible = self.state.isSearching,
		[Roact.Event.Activated] = self.cancelSearchAndEndSession
	}
	local tag = React.Tag
	local v28 = if fFlagLuaAppAddTestIdsForArrow then getTestId("topbar-search-scrim") else nil
	v27[tag] = v28
	v27.ZIndex = 1
	children.DarkOverlay = createElement5("TextButton", v27)

	children.SignalConnection = Roact.createElement(module19, {
		signal = p2,
		callback = self.searchSignalCallback
	})

	children.HiddenItems = self:renderHiddenItems()
	return createElement("Frame", absolutePositionChangedCallbacksByAbsolutePosition, children)
end

function extended:renderHiddenItems()
	return Roact.createElement("Frame", { Visible = false }, {
		leftItem = self.props.leftItem and not self:shouldShowLeftItem() and self:renderTopBarItem(self.props.leftItem),
		centerItem = self.props.centerItem and not self:shouldShowCenterItem() and self:renderTopBarItem(self.props.centerItem)
	})
end

function extended:render()
	return module18(function(p2)
		return withStyle(function(p3)
			return withLocalization({
				pageTitle = self:getPageNameLocalizationKey(),
				searchPlaceholderSearchGames = "Search.GlobalSearch.Example.SearchGames",
				searchPlaceholderSearchMarketplace = "Search.GlobalSearch.Example.SearchMarketplace"
			})(function(p4)
				return self:renderWithProviders(p2, p3, p4)
			end)
		end)
	end)
end

function extended:didUpdate(p2, p3)
	self:updateTopBarHeight(p2, p3)

	self:closeSearchBarIfLeavingPage(p2)
end

function extended:closeSearchBarIfLeavingPage(p2)
	local currentRoute = self.props.currentRoute
	local currentRoute2 = p2.currentRoute

	if
		currentRoute[#currentRoute].name ~= currentRoute2[#currentRoute2].name
		and self.state.isSearching == true
	then
		self.onExitSearch()
	end

	if
		self.props.avatarRoute
		and p2.avatarRoute
		and self.props.avatarRoute.opaque.key ~= p2.avatarRoute.opaque.key
		and self.state.isSearching == true
	then
		self.onExitSearch()
	end
end

local function isInPeekViewFromSearch(list): boolean
	local name = list[#list].name

	return if (module17() and name == module6.GameDetail or name == module6.ProfilePlatform) and #list > 1 then list[#list - 1].name == module6.SearchPage else false
end

local function getShowSearchBar(list): boolean
	if list[#list].name == module6.SearchPage then
		return true
	end

	local name = list[#list].name
	local v12

	if (module17() and name == module6.GameDetail or name == module6.ProfilePlatform) and #list > 1 then
		v12 = list[#list - 1].name == module6.SearchPage
	else
		v12 = false
	end

	if v12 then
		return true
	end

	return false
end

local function getCurrentOpaquePage(list)
	for i = #list, 1, -1 do
		local name = list[i].name
		local v12 = module7[name]

		if v12 == nil or not v12.renderUnderlyingPage then
			return name
		end
	end

	return nil
end

local v12 = module14(function(p2, p3)
	local sideMarginOverride = p3.sideMarginOverride or getPageMargin(p3.screenSize.X)

	return withGridConfig_DEPRECATED(
		{
			[layoutConfig.Keys.PaddingRightItems] = 0,
			[layoutConfig.Keys.PaddingHorizontal] = sideMarginOverride,
			[layoutConfig.Keys.PaddingVertical] = 0
		},
		layoutConfig.Kind
	)(function(p4)
		return Roact.createElement(p2, Cryo.Dictionary.join(p3, { gridConfig = p4 }))
	end)
end)(extended)

local v13 = RoactRodux.connect(function(data, p2)
	local v14

	if not fFlagSignalsNavP3bTopBar then
		if fFlagUseNavigationSelectors then
			v14 = selectors.selectCurrentLegacyRoute(data)
		else
			v14 = data.Navigation.history[#data.Navigation.history]
		end
	end

	local v15 = {
		screenSize = data.ScreenSize,
		formFactor = data.FormFactor,
		currentRoute = v14,
		showSearchBar = 0,
		statusBarHeight = 0,
		opaquePage = 0
	}
	local v16

	if not fFlagSignalsNavP3bTopBar then
		if v14[#v14].name == module6.SearchPage then
			v16 = true
		else
			local name = v14[#v14].name

			v16 = (if (module17() and name == module6.GameDetail or name == module6.ProfilePlatform) and #v14 > 1 then v14[#v14 - 1].name == module6.SearchPage else false)
				and true
				or false
		end
	end

	v15.showSearchBar = v16
	v15.statusBarHeight = data.TopBar.statusBarHeight
	local v17 = if not fFlagSignalsNavP3bTopBar then getCurrentOpaquePage(v14) else nil
	v15.opaquePage = v17
	return v15
end, function(callback)
	return {
		confirmSearch = function(p2, p3)
			return callback(module5(p2, p3))
		end,
		setTopBarHeight = function(p2)
			return callback(module8(p2))
		end
	}
end)(v12)

if fFlagSignalsNavP3bTopBar then
	local v14 = v13

	local function TopBarContainerWithSignals(p2)
		local v15 = useSignalState(getLegacyNavigationStore(false).getCurrentLegacyRoute)
		local createElement = React.createElement

		local union = Cryo.Dictionary.union
		local v18

		if v15[#v15].name == module6.SearchPage then
			v18 = true
		else
			local name = v15[#v15].name

			v18 = (if (module17() and name == module6.GameDetail or name == module6.ProfilePlatform) and #v15 > 1 then v15[#v15 - 1].name == module6.SearchPage else false)
				and true
				or false
		end

		return createElement(
			v14,
			union(p2, {
				currentRoute = v15,
				showSearchBar = v18,
				opaquePage = getCurrentOpaquePage(v15)
			})
		)
	end

	v13 = React.memo(TopBarContainerWithSignals)
end

local v14 = roactServices.connect({
	analytics = module,
	sessionService = appSessionService,
	eventIngest = module2
})(v13)

local v15 = roactAppPolicy.connect(function(data, p2)
	return {
		enableNotifications = data.getNotifications(),
		enableSearch = data.getSearchBar(),
		enableSearchAutoComplete = data.getSearchAutoComplete()
	}
end)(v14)

local v16 = module20(RoactNavigation.withNavigation(v15), { required = false })
local function fn(p2)
	local v17, v18 = module16(p2.hideSiteMessageBanner)
	local v19 = useIsSpatial()
	local v20 = useTokens()

	local v21 = if module28 then v5.useThemeBackground() else nil

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	local v24 = if v21 then p2.backgroundSlot or Roact.createElement(v5.ThemeBackgroundHeaderSlot) else nil
	return createElement(v16, join(p2, {
		bannerContainer = v17,
		totalBannerHeight = v18,
		isSpatial = v19,
		tokens = v20,
		transparentBackground = v21 and true or nil,
		backgroundSlot = v24
	}))
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(fn, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
