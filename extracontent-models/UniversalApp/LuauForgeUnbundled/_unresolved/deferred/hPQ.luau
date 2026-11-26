local CorePackages = game:GetService("CorePackages")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local Otter = require(CorePackages.Packages.Otter)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Promise = require(CorePackages.Packages.Promise)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withGridConfig_DEPRECATED = UIBlox.Core.Layout.Grid.withGridConfig_DEPRECATED
local emptyState = UIBlox.App.Indicator.EmptyState
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local layoutConfig = RobloxAppEnums.LayoutConfig
local appPage = RobloxAppEnums.AppPage
local searchTypes = RobloxAppEnums.SearchTypes
local module2 = require("@luauforge/bundled/ecs")
local reportPromiseLoadingTimeWrapper = module2.Analytics.Timing.reportPromiseLoadingTimeWrapper
local createDiagMetricString = module2.Analytics.Formatters.createDiagMetricString
local diag = module2.Analytics.DefaultAnalyticsService.Diag
local eventStream = module2.Analytics.DefaultAnalyticsService.EventStream
local enums = module2.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigationFocus
local searchSourceEvent = require("@luauforge/bundled/cBc").SearchSourceEvent
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local module3 = require("@luauforge/bundled/egz")
local module4 = require("@luauforge/bundled/dKz")
local visibilityControl = module4.VisibilityControl
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local modules = require("@luauforge/bundled/dtb").Modules
local searchRetrievalStatus = modules.LuaApp.Enum.SearchRetrievalStatus
local context = modules.LuaApp.Components.Search.SearchTypeSelection.Context
local omniSearchSessionUtil = modules.LuaApp.Analytics.Sessions.OmniSearchSessionUtil

local module5 = require("@luauforge/deferred/hPR")
local module6 = require("@luauforge/bundled/fvR")
local module7 = require("@luauforge/deferred/hPS")
local module8 = require("@luauforge/deferred/hPU")
local module9 = require("@luauforge/deferred/egn")
local module10 = require("@luauforge/deferred/hjb")
local module11 = require("@luauforge/deferred/hQf")
local module12 = require("@luauforge/bundled/egD")
local module13 = require("@luauforge/bundled/fzL")
local module14 = require("@luauforge/bundled/fwR")
local module15 = require("@luauforge/bundled/fwS")
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local module16 = require("@luauforge/bundled/fvU")
local module17 = require("@luauforge/deferred/hQi")
local module18 = require("@luauforge/deferred/egp")

local fFlagSearchTopResultsTabEnabledForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSearchTopResultsTabEnabledForAll
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppSearchPeopleUnifiedSchemaFields = SharedFlags.FFlagLuaAppSearchPeopleUnifiedSchemaFields
local fFlagSduiOpenSearchResultsTabAction = SharedFlags.FFlagSduiOpenSearchResultsTabAction
local fFlagLuaAppSearchResultsPageGameTileVideo = SharedFlags.FFlagLuaAppSearchResultsPageGameTileVideo
local searchPageTabSwitchBridge

if fFlagSduiOpenSearchResultsTabAction then
	searchPageTabSwitchBridge = require("@luauforge/bundled/dDZ").SearchPageTabSwitchBridge
else
	searchPageTabSwitchBridge = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local v5 = { frequency = 3, dampeningRatio = 0 }

local v6 = {
	[searchTypes.Games] = module8,
	[searchTypes.Players] = module9,
	[searchTypes.Catalog] = module10,
	[searchTypes.TopResults] = module11,
	[searchTypes.Auto] = UIBlox.App.Container.LoadingStatePage
}
local set

if fFlagAppIaScrollAway then
	set = {}
	set[searchTypes.Games] = true
	set[searchTypes.Players] = true
	set[searchTypes.TopResults] = true
else
	set = nil
end

local function fireAutoSearchLoadingTimeEvent(p2, p3, p4)
	local v7 = p3.status == searchRetrievalStatus.Failed and "omniSearch"
		or getDeepValue(p3, "result.responseBody.vertical") ~= module5.User and "gameSearch"
		or contexts.PlayerSearch

	eventStream:sendEventDeferred(v7, eventTypes.LoadingTime, {
		isAutoSearchType = true,
		status = p3.status,
		loadingTime = p4
	})

	diag:reportStats(createDiagMetricString(p2, p3) .. "_" .. v7, p4)
end

local extended = Roact.PureComponent:extend("SearchPage")

extended.defaultProps = { searchType = searchTypes.Games }

extended.validateProps = t.strictInterface({
	topBarHeight = t.number,
	searchParameters = t.strictInterface({
		searchKeyword = t.string,
		isKeywordSuggestionEnabled = t.boolean
	}),
	searchType = t.string,
	screenSize = t.Vector2,
	currentPage = t.table,
	currentRoute = t.table,
	autoTabSearchStatus = t.string,
	openWebview = t.callback,
	setSearchType = t.callback,
	setSearchParameters = t.callback,
	dispatchOmniSearchAutoFirstPage = t.callback,
	eventIngest = t.any,
	sessionService = t.any,
	networking = t.any,
	useCreationCenterTitle = t.boolean,
	gridConfig = t.table,
	searchUuid = t.optional(t.string),
	omniSearchUuid = t.optional(t.string),
	isFocused = t.boolean,
	isTopPageEnabled = t.optional(t.boolean),
	defaultFocusRef = t.optional(t.callback),
	containerRef = t.optional(t.union(t.table, t.callback)),
	navigation = t.any
})

function extended:init()
	self.isMounted = false
	self.searchTypeSelectorFrameRef = Roact.createRef()
	function self.searchTypeSelectorContainerRef(current)
		self.searchTypeSelectorFrameRef.current = current

		if self.props.defaultFocusRef then
			self.props.defaultFocusRef(current)
		end
	end
	self.searchPageRef = Roact.createRef()

	self.searchComponents = {}
	local searchType = self.props.searchType
	self.searchInfoMap = {}
	self.searchInfoMap[searchType] = {
		searchUuid = self.props.searchUuid,
		searchParameters = self.props.searchParameters
	}

	self.currentSearchType = searchType

	self.state = {
		currentSearchType = searchType,
		isRoutedFromAutoSearch = searchType == searchTypes.Auto
	}

	function self.useSearchTypeSelector()
		return module3.isSearchTypeInOmniSearch(self.state.currentSearchType)
	end

	function self.updateSearchType(currentSearchType, p2)
		if self.state.currentSearchType == currentSearchType then
			return
		end

		if not self.props.searchParameters then
			assert(false, "self.props.searchParameters should not be nil")
			return
		end

		local searchKeyword = self.props.searchParameters.searchKeyword
		local v7

		if self.searchInfoMap[currentSearchType] then
			v7 = self.searchInfoMap[currentSearchType].searchUuid
		else
			if
				self.state.currentSearchType == searchTypes.Auto
				and self.searchInfoMap[searchTypes.Auto]
				and self.searchInfoMap[searchTypes.Auto].searchUuid
			then
				v7 = self.searchInfoMap[searchTypes.Auto].searchUuid
			else
				v7 = searchUuid()
			end

			if
				self.state.currentSearchType ~= searchTypes.Auto
				and currentSearchType ~= searchTypes.Auto
			then
				self:setState({ isRoutedFromAutoSearch = false })
			end

			local v8 = {
				searchKeyword = searchKeyword,
				isKeywordSuggestionEnabled = true
			}

			self.searchInfoMap[currentSearchType] = {
				searchUuid = v7,
				searchParameters = v8
			}

			self.props.setSearchParameters(v7, v8)
			self.props.setSearchType(v7, currentSearchType)
		end

		omniSearchSessionUtil.updateSearchType(self.props.sessionService, currentSearchType, v7, p2)

		local v8 = self.state.currentSearchType == searchTypes.Auto

		if self.currentSearchType ~= currentSearchType then
			local currentRoute = self.props.currentRoute

			local v9 = if v8 then currentRoute[#currentRoute - 1].name else self.props.currentPage.name
			module16(self.props.eventIngest, currentSearchType, "search", searchKeyword, v8, v9)
		end

		self:setState({ currentSearchType = currentSearchType })

		self.currentSearchType = currentSearchType

		if not (fFlagAppIaScrollAway and module4.getScrollAwayEnabled()) then
			self.setTabBarVisible()
		end
	end

	function self.onPageChange(p2)
		local currentPage = self.props.currentPage

		if
			not currentPage
			or not currentPage.name
			or currentPage.name ~= appPage.SearchPage
			or not self.props.isFocused
		then
			return
		end

		local sessionService = self.props.sessionService
		local omniSearchInfo = currentPage.extraProps and currentPage.extraProps.omniSearchInfo

		if omniSearchInfo then
			assert(omniSearchInfo.omniSearchUuid ~= nil)
			assert(omniSearchInfo.searchKeyword ~= nil)

			local omniSearchUuid = omniSearchInfo.omniSearchUuid
			local searchKeyword = omniSearchInfo.searchKeyword

			if
				p2
				and p2.extraProps
				and p2.extraProps.omniSearchInfo
				and omniSearchUuid == p2.extraProps.omniSearchInfo.omniSearchUuid
			then
				return
			end

			local searchInfo = self.searchInfoMap[self.state.currentSearchType]

			local v7 = if searchInfo then searchInfo.searchUuid else nil

			omniSearchSessionUtil.create(
				sessionService,
				omniSearchUuid,
				searchKeyword,
				self.state.currentSearchType,
				v7,
				searchSourceEvent.NavBack
			)
		end
	end

	function self.onTopResultsSelected(p2)
		if not self.isMounted then
			return
		end

		self.updateSearchType(searchTypes.TopResults, p2)
	end

	function self.onGamesSelected(p2)
		if not self.isMounted then
			return
		end

		self.updateSearchType(searchTypes.Games, p2)
	end

	function self.onPlayersSelected(p2)
		if not self.isMounted then
			return
		end

		self.updateSearchType(searchTypes.Players, p2)
	end

	if not (fFlagAppIaScrollAway and module4.getScrollAwayEnabled()) then
		self.selectorVisible = true
		function self.onScrollDirectionChanged(p2)
			local v7 = p2 == module12.Backward

			if v7 ~= self.selectorVisible then
				self.selectorVisible = v7
				self.motor:setGoal({
					searchTypeSelectorFramePosition = Otter.spring(self.getSelectorFramePosition(v7), v5),
					searchPagePosition = Otter.spring(self.getSearchPagePosition(v7), v5),
					searchPageSizeOffset = Otter.spring(self.getSearchPageSizeOffset(v7), v5)
				})
			end
		end

		function self.setTabBarVisible()
			if not self.selectorVisible then
				self.selectorVisible = true
				self.motor:setGoal({
					searchTypeSelectorFramePosition = Otter.spring(
						self.getSelectorFramePosition(self.selectorVisible),
						v5
					),
					searchPagePosition = Otter.spring(self.getSearchPagePosition(self.selectorVisible), v5),
					searchPageSizeOffset = Otter.spring(
						self.getSearchPageSizeOffset(self.selectorVisible),
						v5
					)
				})
			end
		end

		function self.getSelectorFramePosition(p2)
			local v7 = self.props.gridConfig[layoutConfig.Keys.PaddingVertical]
			local v8 = self.props.topBarHeight - v7

			if not p2 then
				v8 -= 43
			end

			return v8
		end

		function self.getSearchPagePosition(p2)
			return self.getSelectorFramePosition(p2) + 43 - 1
		end

		function self.getSearchPageSizeOffset(p2)
			return -self.getSearchPagePosition(p2)
		end
	end

	function self.checkDispatchInitialOmniSearch()
		if searchType == searchTypes.Auto then
			return reportPromiseLoadingTimeWrapper(self.props.dispatchOmniSearchAutoFirstPage, function()
				return { fetch = "search_auto" }
			end, { fireEvent = fireAutoSearchLoadingTimeEvent })(self.props.networking, self.props.searchParameters.searchKeyword, self.props.searchUuid, self.props.omniSearchUuid)
		end

		return Promise.resolve()
	end

	self.buildSearchTypeSelections = memoize(function(p2, p3, p4, p5, p6)
		local v7 = {}

		if fFlagSearchTopResultsTabEnabledForAll or p6 then
			table.insert(v7, {
				name = searchTypes.TopResults,
				text = p2,
				onActivated = self.onTopResultsSelected
			})
		end

		table.insert(v7, {
			name = searchTypes.Games,
			text = p3,
			onActivated = self.onGamesSelected,
			image = not (fFlagSearchTopResultsTabEnabledForAll or p6) and "LuaApp/icons/GameDetails/play" or nil
		})

		if p5 then
			table.insert(v7, {
				name = searchTypes.Players,
				text = p4,
				onActivated = self.onPlayersSelected,
				image = not (fFlagSearchTopResultsTabEnabledForAll or p6) and "LuaApp/icons/avatar_profile" or nil
			})
		end

		return v7
	end)
end

function extended:renderWithLocalized(data2)
	local v7 = self.props.topBarHeight

	local currentSearchType = self.state.currentSearchType
	local searchUuid2 = self.searchInfoMap[currentSearchType].searchUuid
	local searchParameters = self.searchInfoMap[currentSearchType].searchParameters

	local useCreationCenterTitle = self.props.useCreationCenterTitle
	local flag

	if currentSearchType == searchTypes.Catalog then
		v7 = 0
		flag = false
	else
		flag = true
	end

	local v8 = v7

	if self.useSearchTypeSelector() then
		v8 += 43
	end

	local v9

	if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then
		v9 = 0
	else
		v9 = if self.useSearchTypeSelector() then self.getSearchPagePosition(true) or v8 else v8
	end

	local v10 = nil

	if currentSearchType == searchTypes.Games and useCreationCenterTitle then
		v10 = data2.creationCenter
	elseif currentSearchType == searchTypes.Games then
		v10 = data2.chartsTitle
	end

	return withStyle(function(p2)
		local transparency = p2.Theme.BackgroundDefault.Transparency
		local v11 = currentSearchType == searchTypes.Catalog and 1 or transparency
		local v12

		if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() and set[currentSearchType] then
			v12 = v7

			if self.useSearchTypeSelector() then
				v12 += 43
			end
		end

		local createElement = Roact.createElement
		local v13 = v6[currentSearchType]
		local v14 = {
			searchUuid = searchUuid2,
			omniSearchUuid = self.props.omniSearchUuid,
			searchParameters = searchParameters,
			onScrollDirectionChanged = self.useSearchTypeSelector() and self.onScrollDirectionChanged or nil,
			isRoutedFromAutoSearch = self.state.isRoutedFromAutoSearch,
			canvasTopPadding = v12,
			appPage = 0
		}

		local v15 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields and currentSearchType == searchTypes.Players then appPage.SearchPage else nil
		v14.appPage = v15
		local v16 = createElement(v13, v14)

		if
			currentSearchType == searchTypes.Auto
			and self.props.autoTabSearchStatus == searchRetrievalStatus.Failed
		then
			v16 = Roact.createElement(emptyState, {
				onActivated = self.checkDispatchInitialOmniSearch,
				text = data2.failedMessage
			})
		end

		self.searchComponents[currentSearchType] = v16
		local children = {}

		for k, searchComponent in pairs(self.searchComponents) do
			children[k] = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				Visible = k == currentSearchType
			}, { SearchComponent = searchComponent })
		end

		local v17 = fFlagAppIaScrollAway and module4.getScrollAwayEnabled() and 0
			or self.useSearchTypeSelector() and self.getSearchPageSizeOffset(true)
			or -v8

		local searchTypeSelections = self.buildSearchTypeSelections(
			data2.topResults,
			data2.games,
			data2.players,
			searchParameters ~= nil,
			self.props.isTopPageEnabled
		)

		local createElement2 = Roact.createElement
		local containerRefsByRef = {
			[Roact.Ref] = self.props.containerRef,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}

		local v20 = if flag then Roact.createElement(module6.Container, {
			ZIndex = 3,
			searchType = currentSearchType,
			searchParameters = searchParameters,
			titleText = v10,
			leftItem = module6.BackButton,
			rightItems = { module6.SearchButton, module6.BuyRobuxButton, module6.NotificationsButton }
		}) else nil

		local v21 = self.useSearchTypeSelector()

		if v21 then
			local createElement3 = Roact.createElement
			local searchTypeSelectorContainerRefsByRef = {}
			searchTypeSelectorContainerRefsByRef.Size = UDim2.new(1, 0, 0, 43)
			local v23

			if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then
				v23 = visibilityControl.getHeaderBinding():map(function(p3)
					local v24 = p3 * (v7 + 43) - 43
					return UDim2.fromOffset(0, v24)
				end)
			else
				v23 = UDim2.new(0, 0, 0, self.getSelectorFramePosition(true))
			end

			searchTypeSelectorContainerRefsByRef.Position = v23

			searchTypeSelectorContainerRefsByRef.BackgroundColor3 = p2.Theme.BackgroundDefault.Color
			searchTypeSelectorContainerRefsByRef.BackgroundTransparency = v11
			searchTypeSelectorContainerRefsByRef.BorderSizePixel = 0
			searchTypeSelectorContainerRefsByRef.ZIndex = 2
			searchTypeSelectorContainerRefsByRef[Roact.Ref] = self.searchTypeSelectorContainerRef
			v21 = createElement3("Frame", searchTypeSelectorContainerRefsByRef, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10)
				}),
				SearchTypeSelector = Roact.createElement(module7, {
					selections = searchTypeSelections,
					activeSelection = currentSearchType,
					size = UDim2.new(1, 0, 0, 32),
					backgroundColor3 = p2.Theme.BackgroundDefault.Color,
					backgroundTransparency = v11,
					layoutOrder = 1,
					leftRightPadding = module3.getPageSideMargin(self.props.screenSize.X),
					newDesignEnabled = self.props.isTopPageEnabled or fFlagSearchTopResultsTabEnabledForAll
				}),
				Divider = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					LayoutOrder = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = p2.Theme.Divider.Color,
					BackgroundTransparency = p2.Theme.Divider.Transparency
				})
			})
		end

		return createElement2("Frame", containerRefsByRef, {
			TopBar = v20,
			SearchTypeSelectorFrame = v21,
			SearchTypeSelectionContextProvider = React.createElement(context.Provider, {
				value = {
					selections = searchTypeSelections,
					activeSearchType = if fFlagLuaAppSearchResultsPageGameTileVideo then currentSearchType else nil
				}
			}, {
				SearchPage = Roact.createElement("Frame", {
					BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
					BackgroundTransparency = v11,
					ZIndex = 1,
					Position = UDim2.new(0, 0, 0, v9),
					Size = UDim2.new(1, 0, 1, v17),
					BorderSizePixel = self.useSearchTypeSelector() and 0 or nil,
					[Roact.Ref] = self.useSearchTypeSelector() and self.searchPageRef or nil
				}, children)
			})
		})
	end)
end

function extended:render()
	return withLocalization({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		games = "CommonUI.Features.Label.Games",
		players = "CommonUI.Features.Label.Players",
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		chartsTitle = "CommonUI.Features.Label.Charts",
		topResults = "Search.GlobalSearch.TopResultsLabel"
	})(function(p2)
		return (self:renderWithLocalized(p2))
	end)
end

function extended:didMount()
	self.isMounted = true

	if fFlagSduiOpenSearchResultsTabAction then
		self.tabSwitchConnection = searchPageTabSwitchBridge.connect(function(p2, p3)
			if not self.isMounted then
				return
			end

			self.updateSearchType(p2, p3)
		end)
	end

	if not self.useSearchTypeSelector() then
		return
	end

	if not (fFlagAppIaScrollAway and module4.getScrollAwayEnabled()) then
		self.motor = Otter.createGroupMotor({
			searchTypeSelectorFramePosition = self.getSelectorFramePosition(true),
			searchPagePosition = self.getSearchPagePosition(true),
			searchPageSizeOffset = self.getSearchPageSizeOffset(true)
		})

		self.motor:onStep(function(data)
			if self.searchTypeSelectorFrameRef.current then
				self.searchTypeSelectorFrameRef.current.Position = UDim2.new(0, 0, 0, data.searchTypeSelectorFramePosition)
			end

			local searchPagePosition = data.searchPagePosition
			local searchPageSizeOffset = data.searchPageSizeOffset
			self.searchPageRef.current.Position = UDim2.new(0, 0, 0, searchPagePosition)
			self.searchPageRef.current.Size = UDim2.new(1, 0, 1, searchPageSizeOffset)
		end)

		self.motor:start()
	end

	self.checkDispatchInitialOmniSearch()
end

function extended:willUnmount()
	self.isMounted = false

	if fFlagSduiOpenSearchResultsTabAction and self.tabSwitchConnection then
		self.tabSwitchConnection:disconnect()
		self.tabSwitchConnection = nil
	end

	if self.motor then
		self.motor:destroy()
	end
end

function extended.didUpdate(data, p2, p3)
	if p2.currentPage ~= data.props.currentPage then
		data.onPageChange(p2.currentPage)
	end

	local currentSearchType = data.state.currentSearchType

	if data.props.searchType ~= currentSearchType and currentSearchType == searchTypes.Auto then
		data.updateSearchType(data.props.searchType, searchSourceEvent.AutoRouting)
	end
end

local v7 = RoactRodux.connect(function(data, p2)
	local v8

	if not fFlagSignalsNavP3dRouteGated then
		if fFlagUseNavigationSelectors then
			v8 = selectors.selectCurrentLegacyRoute(data)
		else
			v8 = data.Navigation.history[#data.Navigation.history]
		end
	end

	local searchesParameter = data.SearchesParameters[p2.searchUuid]
	local v9 = {
		topBarHeight = data.TopBar.topBarHeight,
		searchParameters = searchesParameter,
		searchType = data.SearchesTypes[p2.searchUuid],
		screenSize = data.ScreenSize,
		currentPage = 0,
		currentRoute = 0,
		autoTabSearchStatus = 0
	}
	local v10 = if not fFlagSignalsNavP3dRouteGated then v8[#v8] else nil
	v9.currentPage = v10
	v9.currentRoute = v8
	v9.autoTabSearchStatus = searchesParameter and module18(data, searchesParameter.searchKeyword)
		or searchRetrievalStatus.NotStarted
	return v9
end, function(callback)
	return {
		openWebview = function(p2, p3)
			return callback(module13(p2, p3))
		end,
		setSearchType = function(p2, p3)
			return callback(module14(p2, p3))
		end,
		setSearchParameters = function(p2, p3)
			return callback(module15(p2, p3))
		end,
		dispatchOmniSearchAutoFirstPage = function(p2, p3, p4, p5)
			return callback(module17(p2, {
				searchKeyword = p3,
				searchUuid = p4,
				omniSearchUuid = p5
			}))
		end
	}
end)(extended)

local v8 = roactServices.connect({
	eventIngest = appEventIngestService,
	sessionService = appSessionService,
	networking = roactNetworking
})(v7)

local v9 = roactAppPolicy.connect(function(p2, p3)
	return {
		useCreationCenterTitle = p2.getGamesPageCreationCenterTitle()
	}
end)(v8)

return function(p2)
	local v10 = useNavigationProps(function(p3, p4)
		if p3 then
			return {
				searchUuid = p3,
				omniSearchUuid = p4.omniSearchInfo and p4.omniSearchInfo.omniSearchUuid
			}
		end

		return {}
	end)

	local v11 = useNavigationFocus()
	local v12, v13 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local v14

	if fFlagSearchTopResultsTabEnabledForAll then
		v14 = nil
	else
		v14 = useUserExperiment({ appUserLayers.OmniSearchResultsPageUXExposureLayer }, function(p3)
			return (p3[appUserLayers.OmniSearchResultsPageUXExposureLayer] or {}).isTopPageEnabled
		end, false)
	end

	local v15, v16

	if fFlagSignalsNavP3dRouteGated then
		v15 = useSignalState(getLegacyNavigationStore(false).getCurrentLegacyRoute)
		v16 = v15[#v15]
	else
		v16 = nil
		v15 = nil
	end

	return withGridConfig_DEPRECATED({ [layoutConfig.Keys.PaddingVertical] = 0 }, layoutConfig.Kind)(function(p3)
		return Roact.createElement(v9, Cryo.Dictionary.join(p2, {
			gridConfig = p3,
			isFocused = v11,
			isTopPageEnabled = fFlagSearchTopResultsTabEnabledForAll or v14,
			defaultFocusRef = v12,
			containerRef = v13,
			currentPage = if fFlagSignalsNavP3dRouteGated then v16 else nil,
			currentRoute = if fFlagSignalsNavP3dRouteGated then v15 else nil
		}, v10))
	end)
end
