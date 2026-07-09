local Workspace = game:GetService("Workspace")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local TopicInfosReducer = require(CorePackages.Workspace.Packages.TopicInfosRodux).TopicInfosReducer
local TopicContentsReducer = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsReducer
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local withStyle = UIBlox.Style.withStyle
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppLogging = RoactServiceTags.AppLogging
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local GameCollectionItemTypes = require(CorePackages.Workspace.Packages.GameCollections).GameCollectionItemTypes
local SendGameImpressions = require(CorePackages.Workspace.Packages.GameCollections).SendGameImpressions
local DiscoveryAnalytics = require(CorePackages.Workspace.Packages.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local sortDeeplinkFailureCounter = DiscoveryAnalytics.Events.sortDeeplinkFailureCounter
local Context = DiscoveryAnalytics.Constants.Context
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useDeviceType = require(CorePackages.Workspace.Packages.RobloxAppHooks).useDeviceType
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local IconWithTooltip = require(CorePackages.Workspace.Packages.AppBlox).IconWithTooltip
local OpenInfoPeekView = require(CorePackages.Workspace.Packages.DiscoveryRouting).OpenInfoPeekView
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local GameSortGroups = DiscoveryTypes.GameSortGroups
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local GameTileConstants = require(CorePackages.Workspace.Packages.GameTile).GameTileConstants
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local SduiSeeAllGrid = require(CorePackages.Workspace.Packages.ServerDrivenUi).SduiSeeAllGrid
local isSduiGameOmniFeedItem = require(CorePackages.Workspace.Packages.ServerDrivenUi).isSduiGameOmniFeedItem
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useAnimateScrollViewToSelection = require(CorePackages.Workspace.Packages.AppBlox).useAnimateScrollViewToSelection
local useLastInputMode = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useLastInputMode
local NavigateBack = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateBack
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local ApiFetchGamesInSort = Modules.LuaApp.Thunks.Games.ApiFetchGamesInSort
local FetchDataWithErrorToasts = Modules.LuaApp.Thunks.FetchDataWithErrorToasts
local ApiFetchOmniRecommendationsMetadata = Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendationsMetadata
local ApiFetchOmniRecommendations = Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local GameGridSelector = Modules.LuaApp.Components.Games.GameGridSelector
local ApiFetchGamesData = Modules.LuaApp.Thunks.Games.ApiFetchGamesData
local RefreshGameSorts = Modules.LuaApp.Thunks.RefreshGameSorts
local RefreshExpiringSortTokens = Modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local CollectionViews = require(CorePackages.Workspace.Packages.CollectionViews)
local usePageSideMargin = CollectionViews.usePageSideMargin
local useCollectionLayout = CollectionViews.useCollectionLayout
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules2.LuaApp.Constants)
local FitChildren = require(Modules2.LuaApp.FitChildren)
local FitTextLabel = require(Modules2.LuaApp.Components.FitTextLabel)
local GamesDropDownList = require(Modules2.LuaApp.Components.Games.GamesDropDownList)
local GameCategoryTabGroup = require(Modules2.LuaApp.Components.Games.GameCategoryTabGroup)
local RefreshScrollingFrameWithLoadMore = require(Modules2.LuaApp.Components.RefreshScrollingFrameWithLoadMore)
local RefreshSiteAlertInfo = require(Modules2.LuaApp.Actions.RefreshSiteAlertInfo)
local PersonalizationTopBar = require(Modules2.Personalization.PersonalizationTopBar)
local SduiChartsSortDetailPage = require(Modules2.Personalization.Games.SduiChartsSortDetailPage)
local useLogSduiChartsExposure = require(Modules2.Personalization.Games.useLogSduiChartsExposure)
local GameSeeAllImpressionsDetector = require(Modules2.Personalization.Games.GameSeeAllImpressionsDetector)
local LuaAppGameTileConfig = require(Modules2.LuaApp.Flags.LuaAppGameTileConfig)
local FFlagLuaAppRemoveSeeAllDropdown = require(Modules2.Personalization.Flags.FFlagLuaAppRemoveSeeAllDropdown)
local FFlagLuaAppRemoveSeeAllDropdownIXP = require(Modules2.Personalization.Flags.FFlagLuaAppRemoveSeeAllDropdownIXP)
local v82 = game:DefineFastFlag("LuaAppExplicitErrorOnWidthForSeeAll2", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppSortDeeplinkFix = SharedFlags.FFlagLuaAppSortDeeplinkFix
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppSduiSeeAllLayoutParamsFix = SharedFlags.FFlagLuaAppSduiSeeAllLayoutParamsFix
local FFlagLuaAppLogOmniRecommendationsMetadata = SharedFlags.FFlagLuaAppLogOmniRecommendationsMetadata
local FFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagLuaAppCompositionHome = SharedFlags.FFlagLuaAppCompositionHome
local FFlagLuaAppCompositionCharts = SharedFlags.FFlagLuaAppCompositionCharts
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local v95 = FFlagLuaAppCompositionHome or (FFlagLuaAppCompositionCharts or FFlagLuaAppCompositionAlways)
local FFlagLuaAppChartsAppPage = SharedFlags.FFlagLuaAppChartsAppPage
local FFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local GAME_GRID_PADDING = DiscoveryTypes.Constants.GAME_GRID_PADDING
local SECTION_HEADER_HEIGHT = Constants.SECTION_HEADER_HEIGHT
local t1 = {
	OMNI_HOME = {
		isOmni = true,
		sortType = AppPage.Home
	},
	GAMES = {
		isOmni = false,
		sortType = GameSortGroups.GamesList
	}
}
local _ = {
	Dropdown = "Dropdown",
	Tabs = "Tabs"
}
local v102 = Roact.PureComponent:extend("GamesList")

v102.validateProps = t.strictInterface({
	sortPageId = t.optional(t.string),
	isOmni = t.optional(t.boolean),
	initialSortIndex = t.optional(t.number),
	initialSortName = t.optional(t.string),
	pageContext = t.string,
	contentFrame = t.optional(t.Instance),
	setContentFrame = t.optional(t.callback),
	setScrollingFrame = t.optional(t.callback),
	containerRef = if not FFlagEnableLeftNavOnConsole then nil else t.table,
	isScrollingEnabled = if not FFlagEnableLeftNavOnConsole then nil else t.boolean,
	topBarHeight = t.number,
	screenSize = t.Vector2,
	topicInfos = t.table,
	gameSortContents = t.table,
	sponsoredTooltipTitle = t.string,
	sponsoredTooltipBody = t.string,
	dispatchRefresh = t.callback,
	dispatchRefreshOmni = t.callback,
	dispatchRefreshSortContents = t.callback,
	dispatchLoadMoreGames = t.callback,
	dispatchLoadMoreGamesOmni = t.callback,
	dispatchFetchExpiringTokens = t.callback,
	onActivateTooltip = t.callback,
	navigateBack = t.callback,
	useCreationCenterTitle = t.optional(t.boolean),
	useCategoryScrollList = t.optional(t.boolean),
	deviceType = t.string,
	safeAreaPadding = t.number,
	safeAreaBottomPadding = t.optional(t.number),
	gameGridSidePadding = t.number,
	stableContentWidth = t.optional(t.number),
	categorySelectorHeight = t.optional(t.number),
	topBarCategoriesScrollerPadding = t.optional(t.number),
	topBarCategoriesScrollerHeight = t.optional(t.number),
	backgroundTransparency = t.number,
	hasTopBar = t.boolean,
	hideGameStatsIXP = t.optional(t.boolean),
	hideDropdown = if not FFlagLuaAppRemoveSeeAllDropdownIXP then nil else t.optional(t.boolean),
	navigation = t.optional(t.table),
	screenProps = t.optional(t.table),
	loggingProtocol = t.table,
	networking = t.callback,
	eventIngest = t.table,
	analytics = t.table,
	appAnalytics = t.table
})

function v102.init(p1) -- line: 202
	-- upvalues: Signal (copy), FFlagEnableLeftNavOnConsole (copy), Roact (copy), v82 (copy), Workspace (copy), mutedError (copy), isSduiGameOmniFeedItem (copy), t1 (copy), OmniFeedConstants (copy), DiscoveryTypes (copy), SendGameImpressions (copy), gamePlayIntent (copy), Context (copy), GameCollectionItemTypes (copy)
	function p1.isOmni() -- line: 203
		-- upvalues: p1 (copy)
		return p1.state.selectedOmni
	end

	p1.gamesListViewChangedSignal = Signal.new()
	p1.containerRef = if not FFlagEnableLeftNavOnConsole then Roact.createRef() else p1.props.containerRef

	function p1.setContainerRef(p2) -- line: 208
		-- upvalues: p1 (copy)
		p1.containerRef.current = p2

		if p1.props.setScrollingFrame then
			p1.props.setScrollingFrame(p2)
		end
	end

	local screenSize = p1.props.screenSize
	local gameGridSidePadding = p1.props.gameGridSidePadding
	local v108 = if not p1.props.stableContentWidth then screenSize.X - 2 * gameGridSidePadding else p1.props.stableContentWidth

	if v108 < 0 then
		if v82 then
			if Workspace.CurrentCamera then
				local ViewportSize = Workspace.CurrentCamera.ViewportSize

				mutedError(`See All contentWidth should be positive. screenSize.X: { screenSize.X }; sidePadding: { gameGridSidePadding }; Camera: ({ ViewportSize.X }, { ViewportSize.Y })`)
			else
				mutedError(`See All does not have a Workspace.CurrentCamera! screenSize.X: { screenSize.X }; sidePadding: { gameGridSidePadding }`)
			end
		end

		v108 = 0
	end

	p1:setState({
		sortIndex = if not p1.props.isOmni then nil else p1.props.initialSortIndex,
		sortName = p1.props.initialSortName,
		selectedOmni = p1.props.isOmni,
		contentSize = Vector2.new(v108, screenSize.Y),
		frameSize = screenSize
	})

	function p1.getSelectedSort() -- line: 246
		-- upvalues: p1 (copy)
		return p1.props.topicInfos[p1.state.sortName] or {}
	end
	function p1.getSelectedSortContents() -- line: 250
		-- upvalues: p1 (copy)
		return p1.props.gameSortContents[p1.state.sortName]
	end
	function p1.getSelectedSortIdentifier() -- line: 254
		-- upvalues: p1 (copy)
		return p1.state.sortName
	end
	function p1.isSponsoredSort() -- line: 258
		-- upvalues: p1 (copy)
		local v174 = p1.getSelectedSort()

		if v174 and v174:isSponsored() then
			return true
		end

		return false
	end
	function p1.isSdui() -- line: 267
		-- upvalues: p1 (copy), isSduiGameOmniFeedItem (copy)
		local v175 = p1.getSelectedSort()

		if v175 and isSduiGameOmniFeedItem(v175.treatmentType, v175.topicId) then
			return true
		end

		return false
	end
	function p1.refresh() -- line: 275
		-- upvalues: t1 (copy), p1 (copy), OmniFeedConstants (copy)
		local v176 = t1

		return p1.isOmni() and p1.props.dispatchRefreshOmni(p1.props.networking, p1.props.omniRecommendationsRequest, v176.OMNI_HOME.sortType, OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh, p1.props.loggingProtocol) or p1.props.dispatchRefresh(p1.props.networking, p1.state.sortName, v176.GAMES.sortType)
	end
	function p1.loadMoreGames(p3) -- line: 289
		-- upvalues: DiscoveryTypes (copy), p1 (copy), t1 (copy)
		local v178 = p3 or DiscoveryTypes.Constants.DEFAULT_GAME_FETCH_COUNT
		local dispatchLoadMoreGames = p1.props.dispatchLoadMoreGames
		local networking = p1.props.networking
		local v181 = p1.getSelectedSort()
		local v182 = p1.getSelectedSortContents()

		if p1.isOmni() then
			return p1.props.dispatchLoadMoreGamesOmni(networking, t1.OMNI_HOME.sortType, p1.state.sortIndex, v178, p1.props.loggingProtocol)
		end

		if v182 then
			return dispatchLoadMoreGames(networking, v181, v182.rowsRequested, v178, v182.nextPageExclusiveStartId, v182.nextPageToken)
		end
	end
	function p1.switchToSort(p4, p5, p6) -- line: 318
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		if p4.topicId ~= nil then
			p1.props.analytics.reportFilterChangeWithId(p4.topicId, nil, p6)
			p1:setState({
				selectedOmni = true,
				sortIndex = p5,
				sortName = tostring(p4.topicId)
			})
		else
			p1.props.analytics.reportFilterChangeWithId(p4.gameSetTypeId, p4.gameSetTargetId, p6)
			p1:setState({
				selectedOmni = false,
				sortName = p4.name
			})
		end

		spawn(function() -- line: 341
			-- upvalues: p1 (copy)
			if p1.isMounted then
				p1:setState({
					forceRender = nil
				})
			end
		end)
	end
	function p1.reportGameDetailOpened(p7) -- line: 350
		-- upvalues: p1 (copy)
		local v187 = p1.getSelectedSort()
		local analytics = p1.props.analytics
		local v189 = p1.getSelectedSortContents()
		local v190 = v189 and v189.entries or nil

		if not v190 then
			return
		end

		local v191 = v187 and v187.analyticsTypeId or nil
		local v192 = #v190
		local v193 = v190[p7]
		local placeId = v193.placeId
		local isSponsored = v193.isSponsored
		local adId = v193.adId
		local v197 = v187 and v187.gameSetTargetId
		local universeId = v193.universeId
		local pageContext = p1.props.pageContext
		local v200 = v187 and v187.appliedFilters or nil

		analytics.reportOpenGameDetailWithId(placeId, v191, v197, nil, p7, v192, isSponsored, adId, universeId, pageContext, v200)
	end
	function p1.sendGameImpressionsFromSdui(p8, p9, _: number?, _: number?, b1: boolean?) -- line: 387
		-- upvalues: p1 (copy)
		p1.sendGameImpressions(p8, p9, b1)
	end
	function p1.setLogSduiImpressions(p10) -- line: 397
		-- upvalues: p1 (copy)
		p1:setState({
			logSduiImpressions = p10
		})
	end
	function p1.onCollectionViewabilityChanged() -- line: 403
		-- upvalues: p1 (copy)
		p1.gamesListViewChangedSignal:fire()
	end
	function p1.sendGameImpressions(p11, t2: {[any]: any}?, b2: boolean?) -- line: 407
		-- upvalues: p1 (copy), SendGameImpressions (copy)
		local v210 = p1.getSelectedSortContents()

		if not t2 and not v210 then
			return
		end

		local v211 = p1.getSelectedSort()

		if not v211 then
			return
		end

		local analyticsTypeId = v211.analyticsTypeId
		local gameSetTargetId = v211.gameSetTargetId
		local sortPageId = nil

		if not p1.isOmni() then
			sortPageId = p1.props.sortPageId
		end

		local appliedFilters = v211.appliedFilters
		local pageContext = p1.props.pageContext

		SendGameImpressions.sendFromSeeAll(p1.props.eventIngest, p1.props.appAnalytics, p11, t2 or v210.entries, pageContext, analyticsTypeId, gameSetTargetId, sortPageId, appliedFilters, b2)
	end
	function p1.onAbsoluteContentSizeChanged(p12) -- line: 441
		-- upvalues: p1 (copy)
		if p1.props.stableContentWidth then
			return
		end

		if p1.isMounted and p12 then
			local AbsoluteContentSize = p12.AbsoluteContentSize

			if AbsoluteContentSize == p1.state.contentSize then
				return
			end

			if AbsoluteContentSize.X > 0 and AbsoluteContentSize.Y > 0 then
				p1:setState({
					contentSize = AbsoluteContentSize
				})
			end
		end
	end
	function p1.updateGamesInSort() -- line: 459
		-- upvalues: t1 (copy), p1 (copy)
		local v219 = t1

		p1.props.dispatchFetchExpiringTokens(p1.props.networking, v219.GAMES.sortType)

		local v220 = p1.getSelectedSortContents()
		local v221 = v220 and (not not v220.entries and #v220.entries) or nil

		if v221 ~= nil and v221 == 0 then
			if p1.isOmni() then
				p1.loadMoreGames():catch(function() -- line: 471
					warn("Failed to load omni games")
				end)

				return
			end

			p1.props.dispatchRefreshSortContents(p1.props.networking, p1.state.sortName)
		end
	end
	function p1.reportExperienceLaunched(p13, s1: string?) -- line: 480
		-- upvalues: p1 (copy), gamePlayIntent (copy), Context (copy), GameCollectionItemTypes (copy)
		local v224 = p1.getSelectedSort()

		gamePlayIntent(p1.props.eventIngest, Context.ExperienceTile, {
			placeId = p13.placeId,
			rootPlaceId = tonumber(p13.placeId),
			universeId = p13.universeId,
			sortIndex = tostring(p1.state.sortIndex),
			sortEntryIndex = tostring(p13.index),
			referralSource = s1,
			gameSetTypeId = if not p1.isOmni() then v224.gameSetTypeId else v224.topicId,
			gameSetTargetId = if not p1.isOmni() then v224.gameSetTargetId else nil,
			appliedFilters = v224.appliedFilters,
			nativeAdData = p13.adId,
			pageName = p1.props.pageContext,
			tileType = GameCollectionItemTypes.GameCollectionItemType.GameTile
		})
	end
	function p1.onActivateTooltip() -- line: 498
		-- upvalues: p1 (copy)
		if p1.isMounted and p1.isSponsoredSort() then
			p1.props.onActivateTooltip(p1.props.sponsoredTooltipTitle, p1.props.sponsoredTooltipBody)
		end
	end
end
function v102.renderWithLocalized(p14, p15) -- line: 507
	-- upvalues: LuaAppGameTileConfig (copy), AppPage (copy), FFlagLuaAppRemoveSeeAllDropdown (copy), FFlagLuaAppRemoveSeeAllDropdownIXP (copy), SECTION_HEADER_HEIGHT (copy), t1 (copy), withStyle (copy), GameTileConstants (copy), Roact (copy), IconWithTooltip (copy), TooltipOrientation (copy), PersonalizationTopBar (copy), v95 (copy), CompositionTags (copy), React (copy), GameCategoryTabGroup (copy), FFlagEnableLeftNavOnConsole (copy), RefreshScrollingFrameWithLoadMore (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagLuaAppSduiSeeAllLayoutParamsFix (copy), FFlagExtendScrollingFramesBySafeInsets (copy), GAME_GRID_PADDING (copy), GamesDropDownList (copy), FitTextLabel (copy), FitChildren (copy), SduiSeeAllGrid (copy), GameGridSelector (copy), Context (copy), GameSeeAllImpressionsDetector (copy)
	local topBarHeight = p14.props.topBarHeight
	local v113 = p14.getSelectedSortIdentifier()
	local screenSize = p14.props.screenSize
	local frameSize = p14.state.frameSize
	local contentSize = p14.state.contentSize
	local v117 = p14.getSelectedSort()
	local v118 = p14.getSelectedSortContents()
	local useCreationCenterTitle = p14.props.useCreationCenterTitle
	local gameGridSidePadding = p14.props.gameGridSidePadding
	local v121 = LuaAppGameTileConfig.shouldHideGameStats(p14.props.pageContext, p14.props.hideGameStatsIXP)
	local v122 = not p14.props.useCategoryScrollList and "Dropdown" or "Tabs"

	if not v113 then
		return nil
	end

	if not v118 then
		return nil
	end

	local creationCenter = nil

	if useCreationCenterTitle then
		creationCenter = p15.creationCenter
	elseif p14.props.pageContext == AppPage.Games then
		creationCenter = p15.chartsTitle
	end

	local v124 = FFlagLuaAppRemoveSeeAllDropdown and (not FFlagLuaAppRemoveSeeAllDropdownIXP or p14.props.hideDropdown)
	local u125 = not v124 and 38 or nil
	local n3 = 12
	local v127 = if not v124 then u125 + n3 else n3
	local v128 = v127 + SECTION_HEADER_HEIGHT + 14

	if v122 == "Tabs" then
		u125 = 0
		n3 = 0
		topBarHeight = p14.props.topBarCategoriesScrollerHeight
	end

	local v129 = t1
	local u130 = p14.isSponsoredSort()
	local sponsoredTooltipBody = p14.props.sponsoredTooltipBody
	local v132 = p14.isSdui()

	return withStyle(function(p16) -- line: 562
		-- upvalues: GameTileConstants (copy), Roact (copy), v127 (copy), v117 (copy), IconWithTooltip (copy), TooltipOrientation (copy), p14 (copy), sponsoredTooltipBody (ref), PersonalizationTopBar (copy), creationCenter (ref), v95 (copy), CompositionTags (copy), v122 (copy), React (copy), GameCategoryTabGroup (copy), v129 (copy), v113 (copy), FFlagEnableLeftNavOnConsole (copy), gameGridSidePadding (copy), RefreshScrollingFrameWithLoadMore (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), topBarHeight (ref), v118 (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagLuaAppSduiSeeAllLayoutParamsFix (copy), FFlagExtendScrollingFramesBySafeInsets (copy), GAME_GRID_PADDING (copy), v128 (copy), n3 (ref), v124 (copy), GamesDropDownList (copy), u125 (ref), u130 (ref), FitTextLabel (copy), FitChildren (copy), v132 (copy), SduiSeeAllGrid (copy), GameGridSelector (copy), frameSize (copy), contentSize (copy), screenSize (copy), v121 (copy), Context (copy), GameSeeAllImpressionsDetector (copy)
		local Footer = GameTileConstants.PlayerCountStyleValues.Footer
		local v227 = Roact.createElement("Frame", {
			Name = "TitleWithTooltip",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0, 0, 0, v127)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			Title = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				Text = v117.displayName,
				Font = p16.Font.Header1.Font,
				TextSize = p16.Font.BaseSize * p16.Font.Header1.RelativeSize,
				TextColor3 = p16.Theme.TextEmphasis.Color,
				TextTransparency = p16.Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			GamesListTooltip = Roact.createElement(IconWithTooltip, {
				layoutOrder = 2,
				triggerPointName = "GamesListTooltip",
				tooltipOrientation = TooltipOrientation.Bottom,
				onActivateTooltip = p14.onActivateTooltip,
				hoverText = sponsoredTooltipBody
			})
		})

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p14.props.backgroundTransparency
		}, {
			TopBar = if not p14.props.hasTopBar then nil else Roact.createElement(PersonalizationTopBar, {
				titleText = creationCenter,
				tag = if not v95 then nil else CompositionTags.ContentRegion.Header,
				sideMarginOverride = if not v95 then nil else 0
			}),
			CategorySelectorScrollWrapper = if v122 ~= "Tabs" then nil else Roact.createElement("Frame", {
				[React.Tag] = if not v95 then nil else CompositionTags.ContentRegion.Header,
				Size = UDim2.new(1, 0, 0, p14.props.categorySelectorHeight),
				ZIndex = 2,
				BackgroundColor3 = p16.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p14.props.backgroundTransparency,
				Position = if not v95 then UDim2.fromOffset(0, p14.props.topBarCategoriesScrollerPadding) else nil
			}, {
				GameCategoryTabGroup = Roact.createElement(GameCategoryTabGroup, {
					size = UDim2.new(1, 0, 0, p14.props.categorySelectorHeight),
					sortCategories = v129,
					selectedSortIndex = p14.state.sortIndex,
					selectedSortName = v113,
					onSelected = p14.switchToSort,
					padding = if not v95 then if not FFlagEnableLeftNavOnConsole then {
						top = 0,
						bottom = 0,
						left = p14.props.safeAreaPadding,
						right = p14.props.safeAreaPadding
					} else {
						top = 0,
						bottom = 0,
						left = gameGridSidePadding,
						right = gameGridSidePadding
					} else {
						left = 0,
						right = 0,
						top = 0,
						bottom = 0
					}
				})
			}),
			Scroller = Roact.createElement(RefreshScrollingFrameWithLoadMore, {
				Position = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim2.new(0, 0, 0, topBarHeight) else UDim2.fromOffset(0, 0),
				Size = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim2.new(1, 0, 1, -topBarHeight) else UDim2.fromScale(1, 1),
				BackgroundTransparency = p14.props.backgroundTransparency,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				refresh = p14.refresh,
				onLoadMore = v118.hasMoreRows and p14.loadMoreGames,
				ScrollingEnabled = if not FFlagEnableLeftNavOnConsole then nil else p14.props.isScrollingEnabled,
				createEndOfScrollElement = not v118.hasMoreRows,
				canvasTopPadding = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then nil else topBarHeight,
				canvasSidePadding = if not FFlagLuaAppLayoutParamsInContext then nil else gameGridSidePadding,
				contentFrameRefCallback = if not FFlagLuaAppLayoutParamsInContext then nil else p14.props.setContentFrame,
				AutomaticCanvasSize = if not FFlagLuaAppSduiSeeAllLayoutParamsFix then nil else Enum.AutomaticSize.Y,
				onAbsoluteSizeChangedCallback = function(p17) -- line: 673
					-- upvalues: p14 (copy)
					if p14.isMounted and p17 then
						p14:setState({
							frameSize = p17.AbsoluteSize
						})
					end

					p14.gamesListViewChangedSignal:fire()
				end,
				onCanvasPositionChangedCallback = function() -- line: 681
					-- upvalues: p14 (copy)
					p14.gamesListViewChangedSignal:fire()
				end,
				shouldExtendIntoSafeArea = if not FFlagExtendScrollingFramesBySafeInsets then nil else {
					left = false,
					top = false,
					right = false,
					bottom = true
				},
				contentTag = if not v95 then nil else CompositionTags.ContentRegion.Body,
				[Roact.Ref] = p14.setContainerRef
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					[Roact.Change.AbsoluteContentSize] = p14.onAbsoluteContentSizeChanged
				}),
				Padding = if not v95 then Roact.createElement("UIPadding", {
					PaddingLeft = if not FFlagLuaAppLayoutParamsInContext then UDim.new(0, gameGridSidePadding) else nil,
					PaddingRight = if not FFlagLuaAppLayoutParamsInContext then UDim.new(0, gameGridSidePadding) else nil,
					PaddingTop = UDim.new(0, GAME_GRID_PADDING)
				}) else nil,
				PaddingTopSpacer = if not v95 then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, GAME_GRID_PADDING)
				}),
				TopSection = if v122 ~= "Dropdown" then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v128),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, n3)
					}),
					DropDown = if not v124 then Roact.createElement(GamesDropDownList, {
						size = UDim2.new(1, 0, 0, u125),
						position = UDim2.new(0, 0, 0, 0),
						selectedSortName = v113,
						selectedSortIndex = p14.state.sortIndex,
						onSelected = p14.switchToSort,
						isOmni = p14.isOmni(),
						sortCategories = v129
					}) else nil,
					Title = if not u130 then Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v117.displayName,
						Position = UDim2.new(0, 0, 0, v127),
						Font = p16.Font.Header1.Font,
						TextSize = p16.Font.BaseSize * p16.Font.Header1.RelativeSize,
						TextColor3 = p16.Theme.TextEmphasis.Color,
						TextTransparency = p16.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height
					}) else v227
				}),
				["GameGrid " .. v113] = if not v132 then Roact.createElement(GameGridSelector, {
					LayoutOrder = 2,
					impressionsTag = "GamesList",
					entries = v118.entries,
					reportGameDetailOpened = p14.reportGameDetailOpened,
					windowSize = if not p14.props.stableContentWidth then Vector2.new(contentSize.X, frameSize.Y) else Vector2.new(p14.props.stableContentWidth, frameSize.Y),
					screenSize = screenSize,
					hideGameStats = v121,
					currentSidePadding = gameGridSidePadding,
					reportExperienceLaunched = p14.reportExperienceLaunched,
					launchExperienceEventContext = Context.ExperienceTile,
					playerCountStyle = Footer,
					appCompositionEnabled = not not v95 or nil
				}) else React.createElement(SduiSeeAllGrid, {
					layoutOrder = 2,
					impressionsTag = "GamesList",
					appPage = p14.props.pageContext,
					verticalScrollingFrameRef = p14.containerRef,
					contentFrame = if not FFlagLuaAppLayoutParamsInContext then nil else p14.props.contentFrame,
					scrollViewPositionChangedSignal = p14.gamesListViewChangedSignal,
					collectionId = p14.state.sortName,
					collectionIndex = p14.state.sortIndex,
					setLogImpressions = p14.setLogSduiImpressions,
					sendGameImpressions = p14.sendGameImpressionsFromSdui,
					onCollectionViewabilityChanged = p14.onCollectionViewabilityChanged
				}),
				GameSeeAllImpressionsDetector = Roact.createElement(GameSeeAllImpressionsDetector, {
					impressionsTag = "GamesList",
					parentRef = p14.containerRef,
					scrollViewPositionChangedSignal = p14.gamesListViewChangedSignal,
					sendGameImpressions = if not v132 then p14.sendGameImpressions else p14.state.logSduiImpressions,
					gameSortId = p14.state.sortName
				})
			}),
			SafeAreaBottomPadding = if not p14.props.safeAreaBottomPadding or FFlagEnableLeftNavOnConsole then nil else Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, p14.props.safeAreaBottomPadding)
			})
		})
	end)
end
function v102.render(p18) -- line: 801
	-- upvalues: withLocalization (copy)
	return withLocalization({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		chartsTitle = "CommonUI.Features.Label.Charts"
	})(function(p19) -- line: 805
		-- upvalues: p18 (copy)
		return p18:renderWithLocalized(p19)
	end)
end
function v102.didMount(p20) -- line: 810
	-- upvalues: FFlagLuaAppSortDeeplinkFix (copy), t1 (copy), default (copy), sortDeeplinkFailureCounter (copy)
	p20.isMounted = true

	if not FFlagLuaAppSortDeeplinkFix and (p20.props.pageContext == "Deeplink" and not p20.props.gameSortContents[p20.state.sortName]) then
		p20.props.dispatchFetchExpiringTokens(p20.props.networking, t1.GAMES.sortType):andThen(function() -- line: 819
			-- upvalues: p20 (copy)
			if p20.isMounted then
				p20:setState({
					missingSortLoadComplete = true
				})
			end
		end, function(_) -- line: 825
			-- upvalues: default (copy), sortDeeplinkFailureCounter (copy), p20 (copy)
			default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter)
			p20.props.navigateBack()
		end)

		return
	end

	p20.updateGamesInSort()
end
function v102.willUnmount(p22) -- line: 834
	p22.isMounted = false
end
function v102.didUpdate(p23, p24, p25) -- line: 838
	-- upvalues: FFlagLuaAppSortDeeplinkFix (copy), default (copy), sortDeeplinkFailureCounter (copy)
	if p23.state.sortName ~= p25.sortName or not FFlagLuaAppSortDeeplinkFix and not p24.gameSortContents[p23.state.sortName] and p23.props.gameSortContents[p23.state.sortName] then
		if not FFlagLuaAppSortDeeplinkFix then
			task.spawn(function() -- line: 848
				-- upvalues: p23 (copy)
				if p23.isMounted then
					p23:setState({
						missingSortLoadComplete = false
					})
				end
			end)
		end

		p23.updateGamesInSort()
	end

	if not FFlagLuaAppSortDeeplinkFix and p23.state.missingSortLoadComplete and not p23.props.gameSortContents[p23.state.sortName] then
		default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter)
		p23.props.navigateBack()
	end
end

local v103 = RoactRodux.connect(function(p26, _) -- line: 868
	-- upvalues: TopicInfosReducer (copy), TopicContentsReducer (copy)
	return {
		topBarHeight = p26.TopBar.topBarHeight,
		screenSize = p26.ScreenSize,
		topicInfos = p26.Personalization[TopicInfosReducer.key],
		gameSortContents = p26.Personalization[TopicContentsReducer.key]
	}
end, function(p28) -- line: 875
	-- upvalues: RefreshSiteAlertInfo (copy), FetchDataWithErrorToasts (copy), RefreshGameSorts (copy), ApiFetchOmniRecommendations (copy), ApiFetchGamesData (copy), ApiFetchGamesInSort (copy), ApiFetchOmniRecommendationsMetadata (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy), RefreshExpiringSortTokens (copy), NavigateBack (copy)
	return {
		dispatchRefresh = function(p29, p30, p31) -- line: 877
			-- upvalues: p28 (copy), RefreshSiteAlertInfo (copy), FetchDataWithErrorToasts (copy), RefreshGameSorts (copy)
			p28(RefreshSiteAlertInfo())

			return p28((FetchDataWithErrorToasts((RefreshGameSorts(p29, { p31 }, p30, nil)))))
		end,
		dispatchRefreshOmni = function(p32, p33, p34, p35, p36) -- line: 883
			-- upvalues: p28 (copy), RefreshSiteAlertInfo (copy), FetchDataWithErrorToasts (copy), ApiFetchOmniRecommendations (copy)
			p28(RefreshSiteAlertInfo())

			return p28((FetchDataWithErrorToasts((ApiFetchOmniRecommendations(p32, p33, p34, nil, nil, p35, p36)))))
		end,
		dispatchRefreshSortContents = function(p37, p38) -- line: 905
			-- upvalues: p28 (copy), ApiFetchGamesData (copy)
			return p28(ApiFetchGamesData(p37, nil, p38, nil, nil))
		end,
		dispatchLoadMoreGames = function(p39, p40, p41, p42, p43, p44) -- line: 908
			-- upvalues: p28 (copy), FetchDataWithErrorToasts (copy), ApiFetchGamesInSort (copy)
			return p28((FetchDataWithErrorToasts((ApiFetchGamesInSort(p39, p40, true, {
				startRows = p41,
				maxRows = p42,
				exclusiveStartId = p43,
				pageToken = p44
			})))))
		end,
		dispatchLoadMoreGamesOmni = function(p45, p46, p47, p48, p49) -- line: 916
			-- upvalues: p28 (copy), FetchDataWithErrorToasts (copy), ApiFetchOmniRecommendationsMetadata (copy), FFlagLuaAppLogOmniRecommendationsMetadata (copy)
			return p28((FetchDataWithErrorToasts((ApiFetchOmniRecommendationsMetadata(p45, p46, p47, p48, p49, if not FFlagLuaAppLogOmniRecommendationsMetadata then nil else "GamesList")))))
		end,
		dispatchFetchExpiringTokens = function(p50, p51) -- line: 930
			-- upvalues: p28 (copy), RefreshExpiringSortTokens (copy)
			return p28((RefreshExpiringSortTokens(p50, { p51 })))
		end,
		navigateBack = function() -- line: 933
			-- upvalues: p28 (copy), NavigateBack (copy)
			return p28(NavigateBack())
		end
	}
end)(v102)
local v104 = RoactAppExperiment.connectUserLayer({
	AppUserLayers.GameTileLayer,
	AppUserLayers.PlayerAppSeeAllUXLayer
}, function(p52, _) -- line: 1062
	-- upvalues: AppUserLayers (copy), FFlagLuaAppRemoveSeeAllDropdownIXP (copy)
	local v171 = p52[AppUserLayers.GameTileLayer] or {}
	local v172 = p52[AppUserLayers.PlayerAppSeeAllUXLayer] or {}

	return {
		hideGameStatsIXP = v171.hideGameStats == "true",
		hideDropdown = if not FFlagLuaAppRemoveSeeAllDropdownIXP then nil else v172.ShouldRemoveSeeAllDropdown
	}
end)(function(p54) -- line: 940
	-- upvalues: useLocalization (copy), useDispatch (copy), React (copy), OpenInfoPeekView (copy), useDeviceType (copy), useNavigationProps (copy), FFlagLuaAppChartsAppPage (copy), useAppPolicy (copy), useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), useCollectionLayout (copy), v95 (copy), usePageSideMargin (copy), SignalsReact (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagLuaAppLayoutParamsInContext (copy), FFlagEnableLeftNavOnConsole (copy), useLastInputMode (copy), useAnimateScrollViewToSelection (copy), FFlagLuaAppLogChartsAppPageExposure (copy), useLogSduiChartsExposure (copy), SduiChartsSortDetailPage (copy), Cryo (copy), Roact (copy), v103 (copy)
	local v143 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})
	local SponsoredDisclosure = v143.SponsoredDisclosure
	local SponsoredTitle = v143.SponsoredTitle
	local v146 = useDispatch()
	local v147 = React.useCallback(function(s2: string, s3: string) -- line: 948
		-- upvalues: v146 (copy), OpenInfoPeekView (copy)
		v146(OpenInfoPeekView(s2, s3))
	end, {})
	local v148 = useDeviceType()
	local v149 = useNavigationProps(function(p55, p56) -- line: 954
		-- upvalues: FFlagLuaAppChartsAppPage (copy)
		local t3 = {
			sortPageId = p56.sortPageId,
			pageContext = p56.pageContext,
			pageTimer = if not FFlagLuaAppChartsAppPage then nil else p56.pageTimer,
			initialSortName = p55
		}

		if p56.isOmni then
			t3.isOmni = true
			t3.initialSortIndex = p56.sortIndex
		end

		return t3
	end)
	local v150 = useAppPolicy(function(p57) -- line: 970
		return p57.getGamesPageCreationCenterTitle()
	end)
	local v151 = useAppPolicy(function(p58) -- line: 973
		return p58.getGameListCategoryScrollListEnabled()
	end)
	local v152 = useDesignTokens()
	local v153 = useUiModeInfo()
	local v154 = v153.uiMode ~= UiMode.TenFoot
	local v155 = v153.uiMode == UiMode.TenFoot
	local v156, v157 = React.useState(nil)
	local v158 = useCollectionLayout()
	local v159 = if not v95 then usePageSideMargin(v156) else 0
	local v160 = SignalsReact.useSignalState(v158.getContainerWidth)
	local v161 = if not v95 then nil else math.max(0, v160 - 2 * v158.margin)
	local v162 = if not v155 then nil else if not FFlagRenameDeprecatedUIBloxTokens then v152.Global.Space_500 else v152.Size.Size_1000
	local v163 = nil
	local v164 = nil

	if FFlagLuaAppLayoutParamsInContext then
		v163, v164 = React.useState(nil)
	end

	local v165 = nil
	local v166 = nil

	if FFlagEnableLeftNavOnConsole then
		v165 = React.useRef(nil)
		v166 = useLastInputMode() == "Cursor"
		useAnimateScrollViewToSelection(v165, 0.4)
	end

	local v167 = FFlagLuaAppChartsAppPage and (not v149.isOmni and not p54.isOmni)

	if FFlagLuaAppLogChartsAppPageExposure then
		useLogSduiChartsExposure(v167)
	end

	if v167 then
		return React.createElement(SduiChartsSortDetailPage, {
			sortId = v149.initialSortName or p54.initialSortName,
			pageContext = v149.pageContext or p54.pageContext,
			pageTimer = v149.pageTimer
		})
	end

	local v168 = Cryo.Dictionary.join(p54, {
		deviceType = v148,
		onActivateTooltip = v147,
		sponsoredTooltipBody = SponsoredDisclosure,
		sponsoredTooltipTitle = SponsoredTitle,
		useCreationCenterTitle = v150,
		useCategoryScrollList = v151,
		categorySelectorHeight = if not FFlagRenameDeprecatedUIBloxTokens then v152.Global.Size_600 else v152.Size.Size_1200,
		topBarCategoriesScrollerHeight = if not FFlagRenameDeprecatedUIBloxTokens then v152.Global.Size_1000 else v152.Size.Size_2000,
		topBarCategoriesScrollerPadding = if not FFlagRenameDeprecatedUIBloxTokens then v152.Global.Space_200 else v152.Size.Size_400,
		hasTopBar = v154,
		backgroundTransparency = v152.LuaApps.SeeAll.BackgroundTransparency,
		safeAreaPadding = if not FFlagRenameDeprecatedUIBloxTokens then v152.Global.Space_800 else v152.Size.Size_1600,
		gameGridSidePadding = v159,
		stableContentWidth = v161,
		safeAreaBottomPadding = v162,
		contentFrame = if not FFlagLuaAppLayoutParamsInContext then nil else v163,
		setContentFrame = if not FFlagLuaAppLayoutParamsInContext then nil else v164,
		setScrollingFrame = v157,
		containerRef = if not FFlagEnableLeftNavOnConsole then nil else v165,
		isScrollingEnabled = if not FFlagEnableLeftNavOnConsole then nil else v166
	}, v149)

	return Roact.createElement(v103, v168)
end)

return RoactServices.connect({
	networking = RoactNetworking,
	eventIngest = AppEventIngestService,
	analytics = RoactAnalyticsCommonGameEvents,
	appAnalytics = RoactAnalytics,
	loggingProtocol = AppLogging
})(v104)
