local CorePackages = game:GetService("CorePackages")
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local Otter = require(CorePackages.Packages.Otter)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Promise = require(CorePackages.Packages.Promise)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withGridConfig_DEPRECATED = UIBlox.Core.Layout.Grid.withGridConfig_DEPRECATED
local EmptyState = UIBlox.App.Indicator.EmptyState
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local LayoutConfig = RobloxAppEnums.LayoutConfig
local AppPage = RobloxAppEnums.AppPage
local SearchTypes = RobloxAppEnums.SearchTypes
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local reportPromiseLoadingTimeWrapper = SocialLuaAnalytics.Analytics.Timing.reportPromiseLoadingTimeWrapper
local createDiagMetricString = SocialLuaAnalytics.Analytics.Formatters.createDiagMetricString
local Diag = SocialLuaAnalytics.Analytics.DefaultAnalyticsService.Diag
local EventStream = SocialLuaAnalytics.Analytics.DefaultAnalyticsService.EventStream
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local getDeepValue = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local useNavigationFocus = require(CorePackages.Workspace.Packages.Navigation).useNavigationFocus
local SearchSourceEvent = require(CorePackages.Workspace.Packages.DiscoveryTypes).SearchSourceEvent
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SearchRetrievalStatus = Modules.LuaApp.Enum.SearchRetrievalStatus
local Context = Modules.LuaApp.Components.Search.SearchTypeSelection.Context
local OmniSearchSessionUtil = Modules.LuaApp.Analytics.Sessions.OmniSearchSessionUtil
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local OmniSearchVerticalType = require(Modules2.LuaApp.Enum.OmniSearchVerticalType)
local TopBar = require(Modules2.LuaApp.Components.TopBar.TopBar)
local ButtonStripSelector = require(Modules2.LuaApp.Components.Search.ButtonStripSelector)
local GamesSearchPage = require(Modules2.LuaApp.Components.Search.GamesSearchPage)
local PlayerSearch = require(Modules2.LuaApp.Components.UserSearch.Players.PlayerSearch)
local CatalogSearch = require(Modules2.AvatarExperience.Catalog.Components.Search.CatalogSearch)
local TopResultsSearchPage = require(Modules2.LuaApp.Components.Search.TopResultsSearchPage.TopResultsSearchPage)
local ScrollMovementDirection = require(Modules2.LuaApp.Enum.ScrollMovementDirection)
local OpenWebview = require(Modules2.LuaApp.Thunks.OpenWebview)
local SetSearchType = require(Modules2.LuaApp.Actions.SetSearchType)
local SetSearchParameters = require(Modules2.LuaApp.Actions.SetSearchParameters)
local SearchUuid = require(Modules2.LuaApp.SearchUuid)
local search = require(Modules2.LuaApp.Analytics.Events.search)
local ApiFetchOmniSearchAutoFirstPage = require(Modules2.LuaApp.Thunks.Search.ApiFetchOmniSearchAutoFirstPage)
local getAutoFetchingStatus = require(Modules2.LuaApp.Thunks.Search.getAutoFetchingStatus)
local FFlagSearchTopResultsTabEnabledForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchTopResultsTabEnabledForAll
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = SharedFlags.FFlagLuaAppSearchPeopleUnifiedSchemaFields
local FFlagLuaAppSearchStandardizeAssetCategorization = SharedFlags.FFlagLuaAppSearchStandardizeAssetCategorization
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local FFlagSduiOpenSearchResultsTabAction = SharedFlags.FFlagSduiOpenSearchResultsTabAction
local v72 = if not FFlagSduiOpenSearchResultsTabAction then nil else require(CorePackages.Workspace.Packages.ServerDrivenUi).SearchPageTabSwitchBridge
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v74 = if not FFlagSignalsNavP3dRouteGated then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local t1 = {
	frequency = 3,
	dampeningRatio = 0
}
local t2 = {
	[SearchTypes.Games] = GamesSearchPage,
	[SearchTypes.Players] = PlayerSearch,
	[SearchTypes.Catalog] = CatalogSearch,
	[SearchTypes.TopResults] = TopResultsSearchPage,
	[SearchTypes.Auto] = UIBlox.App.Container.LoadingStatePage
}
local v77 = if not FFlagAppIaScrollAway then nil else {
	[SearchTypes.Games] = true,
	[SearchTypes.Players] = true,
	[SearchTypes.TopResults] = true
}

local function fireAutoSearchLoadingTimeEvent(p1, p2, p3) -- line: 124
	-- upvalues: SearchRetrievalStatus (copy), getDeepValue (copy), OmniSearchVerticalType (copy), Contexts (copy), EventStream (copy), EventTypes (copy), createDiagMetricString (copy), Diag (copy)
	local v86 = if p2.status ~= SearchRetrievalStatus.Failed then getDeepValue(p2, "result.responseBody.vertical") ~= OmniSearchVerticalType.User and "gameSearch" or Contexts.PlayerSearch else "omniSearch"

	EventStream:sendEventDeferred(v86, EventTypes.LoadingTime, {
		isAutoSearchType = true,
		status = p2.status,
		loadingTime = p3
	})

	local v87 = createDiagMetricString(p1, p2) .. "_" .. v86

	Diag:reportStats(v87, p3)
end

local v79 = Roact.PureComponent:extend("SearchPage")

v79.defaultProps = {
	searchType = SearchTypes.Games
}
v79.validateProps = t.strictInterface({
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
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	containerRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.union(t.table, t.callback)),
	navigation = t.any
})

function v79.init(p4) -- line: 188
	-- upvalues: Roact (copy), FFlagLuaAppsDefaultSelection (copy), SearchTypes (copy), DiscoveryUtils (copy), SearchUuid (copy), OmniSearchSessionUtil (copy), search (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), AppPage (copy), SearchSourceEvent (copy), ScrollMovementDirection (copy), Otter (copy), t1 (copy), LayoutConfig (copy), reportPromiseLoadingTimeWrapper (copy), fireAutoSearchLoadingTimeEvent (copy), Promise (copy), memoize (copy), FFlagSearchTopResultsTabEnabledForAll (copy)
	p4.isMounted = false
	p4.searchTypeSelectorFrameRef = Roact.createRef()
	p4.searchTypeSelectorContainerRef = if not FFlagLuaAppsDefaultSelection then nil else function(p5) -- line: 192
		-- upvalues: p4 (copy)
		p4.searchTypeSelectorFrameRef.current = p5

		if p4.props.defaultFocusRef then
			p4.props.defaultFocusRef(p5)
		end
	end
	p4.searchPageRef = Roact.createRef()
	p4.searchComponents = {}

	local searchType = p4.props.searchType

	p4.searchInfoMap = {}
	p4.searchInfoMap[searchType] = {
		searchUuid = p4.props.searchUuid,
		searchParameters = p4.props.searchParameters
	}
	p4.currentSearchType = searchType
	p4.state = {
		currentSearchType = searchType,
		isRoutedFromAutoSearch = searchType == SearchTypes.Auto
	}

	function p4.useSearchTypeSelector() -- line: 215
		-- upvalues: DiscoveryUtils (copy), p4 (copy)
		return DiscoveryUtils.isSearchTypeInOmniSearch(p4.state.currentSearchType)
	end
	function p4.updateSearchType(p6, p7) -- line: 219
		-- upvalues: p4 (copy), SearchTypes (copy), SearchUuid (copy), OmniSearchSessionUtil (copy), search (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy)
		if p6 == p4.state.currentSearchType then
			return
		end

		if not p4.props.searchParameters then
			assert(false, "self.props.searchParameters should not be nil")

			return
		end

		local searchKeyword = p4.props.searchParameters.searchKeyword
		local searchUuid

		if p4.searchInfoMap[p6] then
			searchUuid = p4.searchInfoMap[p6].searchUuid
		else
			searchUuid = if p4.state.currentSearchType ~= SearchTypes.Auto or (not p4.searchInfoMap[SearchTypes.Auto] or not p4.searchInfoMap[SearchTypes.Auto].searchUuid) then SearchUuid() else p4.searchInfoMap[SearchTypes.Auto].searchUuid

			if p4.state.currentSearchType ~= SearchTypes.Auto and p6 ~= SearchTypes.Auto then
				p4:setState({
					isRoutedFromAutoSearch = false
				})
			end

			local t3 = {
				isKeywordSuggestionEnabled = true,
				searchKeyword = searchKeyword
			}

			p4.searchInfoMap[p6] = {
				searchUuid = searchUuid,
				searchParameters = t3
			}
			p4.props.setSearchParameters(searchUuid, t3)
			p4.props.setSearchType(searchUuid, p6)
		end

		OmniSearchSessionUtil.updateSearchType(p4.props.sessionService, p6, searchUuid, p7)

		local v132 = p4.state.currentSearchType == SearchTypes.Auto

		if p6 ~= p4.currentSearchType then
			local currentRoute = p4.props.currentRoute
			local v134 = if not v132 then p4.props.currentPage.name else currentRoute[#currentRoute - 1].name

			search(p4.props.eventIngest, p6, "search", searchKeyword, v132, v134)
		end

		p4:setState({
			currentSearchType = p6
		})
		p4.currentSearchType = p6

		if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then
			p4.setTabBarVisible()
		end
	end
	function p4.onPageChange(p8) -- line: 282
		-- upvalues: p4 (copy), AppPage (copy), OmniSearchSessionUtil (copy), SearchSourceEvent (copy)
		local currentPage = p4.props.currentPage

		if not currentPage or (not currentPage.name or currentPage.name ~= AppPage.SearchPage) then
			return
		end

		if not p4.props.isFocused then
			return
		end

		local sessionService = p4.props.sessionService
		local v138 = currentPage.extraProps and currentPage.extraProps.omniSearchInfo

		if v138 then
			assert(v138.omniSearchUuid ~= nil)
			assert(v138.searchKeyword ~= nil)

			local omniSearchUuid = v138.omniSearchUuid
			local searchKeyword = v138.searchKeyword

			if p8 and p8.extraProps and p8.extraProps.omniSearchInfo and omniSearchUuid == p8.extraProps.omniSearchInfo.omniSearchUuid then
				return
			end

			local searchUuid = nil
			local v142 = p4.searchInfoMap[p4.state.currentSearchType]

			if v142 then
				searchUuid = v142.searchUuid
			end

			OmniSearchSessionUtil.create(sessionService, omniSearchUuid, searchKeyword, p4.state.currentSearchType, searchUuid, SearchSourceEvent.NavBack)
		end
	end
	function p4.onTopResultsSelected(p9) -- line: 329
		-- upvalues: p4 (copy), SearchTypes (copy)
		if not p4.isMounted then
			return
		end

		p4.updateSearchType(SearchTypes.TopResults, p9)
	end
	function p4.onGamesSelected(p10) -- line: 337
		-- upvalues: p4 (copy), SearchTypes (copy)
		if not p4.isMounted then
			return
		end

		p4.updateSearchType(SearchTypes.Games, p10)
	end
	function p4.onPlayersSelected(p11) -- line: 344
		-- upvalues: p4 (copy), SearchTypes (copy)
		if not p4.isMounted then
			return
		end

		p4.updateSearchType(SearchTypes.Players, p11)
	end

	if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then
		p4.selectorVisible = true

		function p4.onScrollDirectionChanged(p12) -- line: 353
			-- upvalues: ScrollMovementDirection (copy), p4 (copy), Otter (copy), t1 (copy)
			local v147 = p12 == ScrollMovementDirection.Backward

			if v147 ~= p4.selectorVisible then
				p4.selectorVisible = v147
				p4.motor:setGoal({
					searchTypeSelectorFramePosition = Otter.spring(p4.getSelectorFramePosition(v147), t1),
					searchPagePosition = Otter.spring(p4.getSearchPagePosition(v147), t1),
					searchPageSizeOffset = Otter.spring(p4.getSearchPageSizeOffset(v147), t1)
				})
			end
		end
		function p4.setTabBarVisible() -- line: 368
			-- upvalues: p4 (copy), Otter (copy), t1 (copy)
			if not p4.selectorVisible then
				p4.selectorVisible = true
				p4.motor:setGoal({
					searchTypeSelectorFramePosition = Otter.spring(p4.getSelectorFramePosition(p4.selectorVisible), t1),
					searchPagePosition = Otter.spring(p4.getSearchPagePosition(p4.selectorVisible), t1),
					searchPageSizeOffset = Otter.spring(p4.getSearchPageSizeOffset(p4.selectorVisible), t1)
				})
			end
		end
		function p4.getSelectorFramePosition(p13) -- line: 385
			-- upvalues: p4 (copy), LayoutConfig (copy)
			local v149 = p4.props.gridConfig[LayoutConfig.Keys.PaddingVertical]
			local v150 = p4.props.topBarHeight - v149

			if not p13 then
				v150 -= 43
			end

			return v150
		end
		function p4.getSearchPagePosition(p14) -- line: 396
			-- upvalues: p4 (copy)
			return p4.getSelectorFramePosition(p14) + 43 - 1
		end
		function p4.getSearchPageSizeOffset(p15) -- line: 401
			-- upvalues: p4 (copy)
			return -p4.getSearchPagePosition(p15)
		end
	end

	function p4.checkDispatchInitialOmniSearch() -- line: 406
		-- upvalues: searchType (copy), SearchTypes (copy), reportPromiseLoadingTimeWrapper (copy), p4 (copy), fireAutoSearchLoadingTimeEvent (copy), Promise (copy)
		if searchType == SearchTypes.Auto then
			return reportPromiseLoadingTimeWrapper(p4.props.dispatchOmniSearchAutoFirstPage, function() -- line: 410
				return {
					fetch = "search_auto"
				}
			end, {
				fireEvent = fireAutoSearchLoadingTimeEvent
			})(p4.props.networking, p4.props.searchParameters.searchKeyword, p4.props.searchUuid, p4.props.omniSearchUuid)
		end

		return Promise.resolve()
	end

	p4.buildSearchTypeSelections = memoize(function(p16, p17, p18, p19, p20) -- line: 426
		-- upvalues: FFlagSearchTopResultsTabEnabledForAll (copy), SearchTypes (copy), p4 (copy)
		local t4 = {}

		if FFlagSearchTopResultsTabEnabledForAll or p20 then
			table.insert(t4, {
				name = SearchTypes.TopResults,
				text = p16,
				onActivated = p4.onTopResultsSelected
			})
		end

		table.insert(t4, {
			name = SearchTypes.Games,
			text = p17,
			onActivated = p4.onGamesSelected,
			image = not FFlagSearchTopResultsTabEnabledForAll and not p20 and "LuaApp/icons/GameDetails/play" or nil
		})

		if p19 then
			table.insert(t4, {
				name = SearchTypes.Players,
				text = p18,
				onActivated = p4.onPlayersSelected,
				image = not FFlagSearchTopResultsTabEnabledForAll and not p20 and "LuaApp/icons/avatar_profile" or nil
			})
		end

		return t4
	end)
end
function v79.renderWithLocalized(p21, p22) -- line: 458
	-- upvalues: SearchTypes (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), withStyle (copy), v77 (copy), Roact (copy), t2 (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), AppPage (copy), SearchRetrievalStatus (copy), EmptyState (copy), FFlagLuaAppsDefaultSelection (copy), TopBar (copy), VisibilityControl (copy), ButtonStripSelector (copy), DiscoveryUtils (copy), FFlagSearchTopResultsTabEnabledForAll (copy), React (copy), Context (copy)
	local topBarHeight = p21.props.topBarHeight
	local currentSearchType = p21.state.currentSearchType
	local searchUuid = p21.searchInfoMap[currentSearchType].searchUuid
	local searchParameters = p21.searchInfoMap[currentSearchType].searchParameters
	local useCreationCenterTitle = p21.props.useCreationCenterTitle
	local u97 = true

	if currentSearchType == SearchTypes.Catalog then
		u97 = false
		topBarHeight = 0
	end

	local u98 = topBarHeight

	if p21.useSearchTypeSelector() then
		u98 += 43
	end

	local v99 = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then p21.useSearchTypeSelector() and p21.getSearchPagePosition(true) or u98 else 0
	local creationCenter = nil

	if currentSearchType == SearchTypes.Games and useCreationCenterTitle then
		creationCenter = p22.creationCenter
	elseif currentSearchType == SearchTypes.Games then
		creationCenter = p22.chartsTitle
	end

	return withStyle(function(p23) -- line: 488
		-- upvalues: currentSearchType (copy), SearchTypes (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), v77 (copy), topBarHeight (ref), p21 (copy), Roact (copy), t2 (copy), searchUuid (copy), searchParameters (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), AppPage (copy), SearchRetrievalStatus (copy), EmptyState (copy), p22 (copy), u98 (ref), FFlagLuaAppsDefaultSelection (copy), u97 (ref), TopBar (copy), creationCenter (ref), VisibilityControl (copy), ButtonStripSelector (copy), DiscoveryUtils (copy), FFlagSearchTopResultsTabEnabledForAll (copy), React (copy), Context (copy), v99 (copy)
		local BackgroundDefaultTransparency = p23.Theme.BackgroundDefault.Transparency

		if currentSearchType == SearchTypes.Catalog then
			BackgroundDefaultTransparency = 1
		end

		local v161 = nil

		if FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() and v77[currentSearchType] then
			v161 = topBarHeight

			if p21.useSearchTypeSelector() then
				v161 += 43
			end
		end

		local v162 = Roact.createElement(t2[currentSearchType], {
			searchUuid = searchUuid,
			omniSearchUuid = p21.props.omniSearchUuid,
			searchParameters = searchParameters,
			onScrollDirectionChanged = p21.useSearchTypeSelector() and p21.onScrollDirectionChanged or nil,
			isRoutedFromAutoSearch = p21.state.isRoutedFromAutoSearch,
			canvasTopPadding = v161,
			appPage = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields or currentSearchType ~= SearchTypes.Players then nil else AppPage.SearchPage
		})

		if currentSearchType == SearchTypes.Auto and p21.props.autoTabSearchStatus == SearchRetrievalStatus.Failed then
			v162 = Roact.createElement(EmptyState, {
				onActivated = p21.checkDispatchInitialOmniSearch,
				text = p22.failedMessage
			})
		end

		p21.searchComponents[currentSearchType] = v162

		local t5 = {}

		for k, v in pairs(p21.searchComponents) do
			t5[k] = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Visible = k == currentSearchType
			}, {
				SearchComponent = v
			})
		end

		local v166 = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then p21.useSearchTypeSelector() and p21.getSearchPageSizeOffset(true) or -u98 else 0
		local v167 = p21.buildSearchTypeSelections(p22.topResults, p22.games, p22.players, searchParameters ~= nil, p21.props.isTopPageEnabled)

		return Roact.createElement("Frame", {
			[Roact.Ref] = if not FFlagLuaAppsDefaultSelection then nil else p21.props.containerRef,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			TopBar = if not u97 then nil else Roact.createElement(TopBar.Container, {
				ZIndex = 3,
				searchType = currentSearchType,
				searchParameters = searchParameters,
				titleText = creationCenter,
				leftItem = TopBar.BackButton,
				rightItems = {
					TopBar.SearchButton,
					TopBar.BuyRobuxButton,
					TopBar.NotificationsButton
				}
			}),
			SearchTypeSelectorFrame = p21.useSearchTypeSelector() and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 43),
				Position = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim2.new(0, 0, 0, p21.getSelectorFramePosition(true)) else VisibilityControl.getHeaderBinding():map(function(n1: number) -- line: 569
					-- upvalues: topBarHeight (ref)
					local v189 = n1 * (topBarHeight + 43) - 43

					return UDim2.fromOffset(0, v189)
				end),
				BackgroundColor3 = p23.Theme.BackgroundDefault.Color,
				BackgroundTransparency = BackgroundDefaultTransparency,
				BorderSizePixel = 0,
				ZIndex = 2,
				[Roact.Ref] = if not FFlagLuaAppsDefaultSelection then p21.searchTypeSelectorFrameRef else p21.searchTypeSelectorContainerRef
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10)
				}),
				SearchTypeSelector = Roact.createElement(ButtonStripSelector, {
					layoutOrder = 1,
					selections = v167,
					activeSelection = currentSearchType,
					size = UDim2.new(1, 0, 0, 32),
					backgroundColor3 = p23.Theme.BackgroundDefault.Color,
					backgroundTransparency = BackgroundDefaultTransparency,
					leftRightPadding = DiscoveryUtils.getPageSideMargin(p21.props.screenSize.X),
					newDesignEnabled = p21.props.isTopPageEnabled or FFlagSearchTopResultsTabEnabledForAll
				}),
				Divider = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = p23.Theme.Divider.Color,
					BackgroundTransparency = p23.Theme.Divider.Transparency
				})
			}),
			SearchTypeSelectionContextProvider = React.createElement(Context.Provider, {
				value = {
					selections = v167
				}
			}, {
				SearchPage = Roact.createElement("Frame", {
					BackgroundColor3 = p23.Theme.BackgroundDefault.Color,
					BackgroundTransparency = BackgroundDefaultTransparency,
					ZIndex = 1,
					Position = UDim2.new(0, 0, 0, v99),
					Size = UDim2.new(1, 0, 1, v166),
					BorderSizePixel = if not p21.useSearchTypeSelector() then nil else 0,
					[Roact.Ref] = p21.useSearchTypeSelector() and p21.searchPageRef or nil
				}, t5)
			})
		})
	end)
end
function v79.render(p24) -- line: 624
	-- upvalues: withLocalization (copy), FFlagLuaAppSearchStandardizeAssetCategorization (copy)
	return withLocalization({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		players = "CommonUI.Features.Label.Players",
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		chartsTitle = "CommonUI.Features.Label.Charts",
		topResults = "Search.GlobalSearch.TopResultsLabel",
		games = not FFlagLuaAppSearchStandardizeAssetCategorization and "CommonUI.Features.Label.Game" or "CommonUI.Features.Label.Games"
	})(function(p25) -- line: 634
		-- upvalues: p24 (copy)
		return (p24:renderWithLocalized(p25))
	end)
end
function v79.didMount(p26) -- line: 640
	-- upvalues: FFlagSduiOpenSearchResultsTabAction (copy), v72 (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), Otter (copy)
	p26.isMounted = true

	if FFlagSduiOpenSearchResultsTabAction then
		p26.tabSwitchConnection = v72.connect(function(p27, p28) -- line: 649
			-- upvalues: p26 (copy)
			if not p26.isMounted then
				return
			end

			p26.updateSearchType(p27, p28)
		end)
	end

	if not p26.useSearchTypeSelector() then
		return
	end

	if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then
		p26.motor = Otter.createGroupMotor({
			searchTypeSelectorFramePosition = p26.getSelectorFramePosition(true),
			searchPagePosition = p26.getSearchPagePosition(true),
			searchPageSizeOffset = p26.getSearchPageSizeOffset(true)
		})
		p26.motor:onStep(function(p29) -- line: 666
			-- upvalues: p26 (copy)
			if p26.searchTypeSelectorFrameRef.current then
				p26.searchTypeSelectorFrameRef.current.Position = UDim2.new(0, 0, 0, p29.searchTypeSelectorFramePosition)
			end

			local searchPagePosition = p29.searchPagePosition
			local searchPageSizeOffset = p29.searchPageSizeOffset

			p26.searchPageRef.current.Position = UDim2.new(0, 0, 0, searchPagePosition)
			p26.searchPageRef.current.Size = UDim2.new(1, 0, 1, searchPageSizeOffset)
		end)
		p26.motor:start()
	end

	p26.checkDispatchInitialOmniSearch()
end
function v79.willUnmount(p30) -- line: 684
	-- upvalues: FFlagSduiOpenSearchResultsTabAction (copy)
	p30.isMounted = false

	if FFlagSduiOpenSearchResultsTabAction and p30.tabSwitchConnection then
		p30.tabSwitchConnection:disconnect()
		p30.tabSwitchConnection = nil
	end

	if p30.motor then
		p30.motor:destroy()
	end
end
function v79.didUpdate(p31, p32, _) -- line: 699
	-- upvalues: SearchTypes (copy), SearchSourceEvent (copy)
	if p32.currentPage ~= p31.props.currentPage then
		p31.onPageChange(p32.currentPage)
	end

	local currentSearchType = p31.state.currentSearchType

	if currentSearchType ~= p31.props.searchType and currentSearchType == SearchTypes.Auto then
		p31.updateSearchType(p31.props.searchType, SearchSourceEvent.AutoRouting)
	end
end

local v80 = RoactRodux.connect(function(p34, p35) -- line: 710
	-- upvalues: FFlagSignalsNavP3dRouteGated (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), getAutoFetchingStatus (copy), SearchRetrievalStatus (copy)
	local v110 = if not FFlagSignalsNavP3dRouteGated then if not FFlagUseNavigationSelectors then p34.Navigation.history[#p34.Navigation.history] else Selectors.selectCurrentLegacyRoute(p34) else nil
	local v111 = p34.SearchesParameters[p35.searchUuid]

	return {
		topBarHeight = p34.TopBar.topBarHeight,
		searchParameters = v111,
		searchType = p34.SearchesTypes[p35.searchUuid],
		screenSize = p34.ScreenSize,
		currentPage = if not FFlagSignalsNavP3dRouteGated then v110[#v110] else nil,
		currentRoute = v110,
		autoTabSearchStatus = v111 and getAutoFetchingStatus(p34, v111.searchKeyword) or SearchRetrievalStatus.NotStarted
	}
end, function(p36) -- line: 729
	-- upvalues: OpenWebview (copy), SetSearchType (copy), SetSearchParameters (copy), ApiFetchOmniSearchAutoFirstPage (copy)
	return {
		openWebview = function(p37, p38) -- line: 731
			-- upvalues: p36 (copy), OpenWebview (copy)
			return p36(OpenWebview(p37, p38))
		end,
		setSearchType = function(p39, p40) -- line: 734
			-- upvalues: p36 (copy), SetSearchType (copy)
			return p36(SetSearchType(p39, p40))
		end,
		setSearchParameters = function(p41, p42) -- line: 737
			-- upvalues: p36 (copy), SetSearchParameters (copy)
			return p36(SetSearchParameters(p41, p42))
		end,
		dispatchOmniSearchAutoFirstPage = function(p43, p44, p45, p46) -- line: 740
			-- upvalues: p36 (copy), ApiFetchOmniSearchAutoFirstPage (copy)
			return p36((ApiFetchOmniSearchAutoFirstPage(p43, {
				searchKeyword = p44,
				searchUuid = p45,
				omniSearchUuid = p46
			})))
		end
	}
end)(v79)
local v81 = RoactServices.connect({
	eventIngest = AppEventIngestService,
	sessionService = AppSessionService,
	networking = RoactNetworking
})(v80)
local v82 = RoactAppPolicy.connect(function(p47, _) -- line: 756
	return {
		useCreationCenterTitle = p47.getGamesPageCreationCenterTitle()
	}
end)(v81)

return function(p49) -- line: 766
	-- upvalues: useNavigationProps (copy), useNavigationFocus (copy), FFlagLuaAppsDefaultSelection (copy), ReactFocusNavigation (copy), FFlagSearchTopResultsTabEnabledForAll (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagSignalsNavP3dRouteGated (copy), v74 (copy), useSignalState (copy), withGridConfig_DEPRECATED (copy), LayoutConfig (copy), Roact (copy), v82 (copy), Cryo (copy)
	local v116 = useNavigationProps(function(p50, p51) -- line: 767
		if p50 then
			return {
				searchUuid = p50,
				omniSearchUuid = p51.omniSearchInfo and p51.omniSearchInfo.omniSearchUuid
			}
		end

		return {}
	end)
	local v117 = useNavigationFocus()
	local u118 = nil
	local u119 = nil

	if FFlagLuaAppsDefaultSelection then
		local v120, v121 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()

		u118 = v120
		u119 = v121
	end

	local u122 = nil

	if not FFlagSearchTopResultsTabEnabledForAll then
		u122 = useUserExperiment({ AppUserLayers.OmniSearchResultsPageUXExposureLayer }, function(p52) -- line: 786
			-- upvalues: AppUserLayers (copy)
			return (p52[AppUserLayers.OmniSearchResultsPageUXExposureLayer] or {}).isTopPageEnabled
		end, false)
	end

	local u123 = nil
	local u124 = nil

	if FFlagSignalsNavP3dRouteGated then
		local v125 = v74(false)

		u124 = useSignalState(v125.getCurrentLegacyRoute)
		u123 = u124[#u124]
	end

	return withGridConfig_DEPRECATED({
		[LayoutConfig.Keys.PaddingVertical] = 0
	}, LayoutConfig.Kind)(function(p53) -- line: 805
		-- upvalues: Roact (copy), v82 (copy), Cryo (copy), p49 (copy), v117 (copy), FFlagSearchTopResultsTabEnabledForAll (copy), u122 (ref), FFlagLuaAppsDefaultSelection (copy), u118 (ref), u119 (ref), FFlagSignalsNavP3dRouteGated (copy), u123 (ref), u124 (ref), v116 (copy)
		return Roact.createElement(v82, Cryo.Dictionary.join(p49, {
			gridConfig = p53,
			isFocused = v117,
			isTopPageEnabled = FFlagSearchTopResultsTabEnabledForAll or u122,
			defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else u118,
			containerRef = if not FFlagLuaAppsDefaultSelection then nil else u119,
			currentPage = if not FFlagSignalsNavP3dRouteGated then nil else u123,
			currentRoute = if not FFlagSignalsNavP3dRouteGated then nil else u124
		}, v116))
	end)
end
