local Workspace = game:GetService("Workspace")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local topicInfosReducer = require("@luauforge/bundled/dCQ").TopicInfosReducer
local topicContentsReducer = require("@luauforge/bundled/dCO").TopicContentsReducer
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local withStyle = UIBlox.Style.withStyle
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local appLogging = RoactServiceTags.AppLogging
local roactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local appEventIngestService = RoactServiceTags.AppEventIngestService
local roactAnalytics = RoactServiceTags.RoactAnalytics
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local gameCollectionItemTypes = require("@luauforge/deferred/gEW").GameCollectionItemTypes
local sendGameImpressions = require("@luauforge/deferred/gEW").SendGameImpressions
local module2 = require("@luauforge/bundled/dzG")
local gamePlayIntent = module2.Events.gamePlayIntent
local sortDeeplinkFailureCounter = module2.Events.sortDeeplinkFailureCounter
local context = module2.Constants.Context
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useDeviceType = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useDeviceType
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/AppBlox").IconWithTooltip
local openInfoPeekView = require("@luauforge/bundled/gCm").OpenInfoPeekView
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module3 = require("@luauforge/bundled/cBc")
local gameSortGroups = module3.GameSortGroups
local omniFeedConstants = module3.OmniFeedConstants
local gameTileConstants = require("@luauforge/bundled/gDC").GameTileConstants
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local sduiSeeAllGrid = require("@luauforge/bundled/dDZ").SduiSeeAllGrid
local isSduiGameOmniFeedItem = require("@luauforge/bundled/dDZ").isSduiGameOmniFeedItem
local module4 = require("@luauforge/bundled/dKz")
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/AppBlox").useAnimateScrollViewToSelection
local useLastInputMode = require("@luauforge/bundled/ehL").useLastInputMode

local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local modules = require("@luauforge/bundled/dtb").Modules
local apiFetchGamesInSort = modules.LuaApp.Thunks.Games.ApiFetchGamesInSort
local fetchDataWithErrorToasts = modules.LuaApp.Thunks.FetchDataWithErrorToasts
local apiFetchOmniRecommendationsMetadata = modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendationsMetadata
local apiFetchOmniRecommendations = modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local gameGridSelector = modules.LuaApp.Components.Games.GameGridSelector
local apiFetchGamesData = modules.LuaApp.Thunks.Games.ApiFetchGamesData
local refreshGameSorts = modules.LuaApp.Thunks.RefreshGameSorts
local refreshExpiringSortTokens = modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useCollectionLayout = require("@luauforge/bundled/ehg").useCollectionLayout
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local module5 = require("@luauforge/bundled/dzD")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local module6 = require("@luauforge/bundled/hPr")
local module7 = require("@luauforge/deferred/hPB")
local module8 = require("@luauforge/bundled/egC")
local module9 = require("@luauforge/bundled/dzL")
local getSiteMessageStore = require("@luauforge/bundled/fyU").GetSiteMessageStore
local module10 = require("@luauforge/bundled/hPC")
local module11 = require("@luauforge/deferred/hPH")
local module12 = require("@luauforge/deferred/hPJ")
local module13 = require("@luauforge/deferred/hPL")
local module14 = require("@luauforge/deferred/hPM")

local module15 = require("@luauforge/deferred/hPN")
local module16 = require("@luauforge/deferred/hPO")

local defineFastFlag = game:DefineFastFlag("LuaAppExplicitErrorOnWidthForSeeAll2", false)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForSiteMessage = SharedFlags.FFlagUseSignalsForSiteMessage

local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local v5 = if SharedFlags.FFlagLuaAppSduiHomePageSupport then require("@luauforge/deferred/hPP") else nil

local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppSortDeeplinkFix = SharedFlags.FFlagLuaAppSortDeeplinkFix
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppSduiSeeAllLayoutParamsFix = SharedFlags.FFlagLuaAppSduiSeeAllLayoutParamsFix
local fFlagLuaAppLogOmniRecommendationsMetadata = SharedFlags.FFlagLuaAppLogOmniRecommendationsMetadata
local fFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local fFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local fFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry

local module18 = require("@luauforge/bundled/hPK")
local module19 = require("@luauforge/bundled/ehR")

local GAME_GRID_PADDING = module3.Constants.GAME_GRID_PADDING
local SECTION_HEADER_HEIGHT = module5.SECTION_HEADER_HEIGHT

local v6 = {
	OMNI_HOME = { sortType = appPage.Home, isOmni = true },
	GAMES = { sortType = gameSortGroups.GamesList, isOmni = false }
}

local v7 = { Dropdown = "Dropdown", Tabs = "Tabs" }

local extended = Roact.PureComponent:extend("GamesList")

local strictInterface = t.strictInterface
local v8 = {
	sortPageId = t.optional(t.string),
	isOmni = t.optional(t.boolean),
	initialSortIndex = t.optional(t.number),
	initialSortName = t.optional(t.string),
	pageContext = t.string,
	contentFrame = t.optional(t.Instance),
	setContentFrame = t.optional(t.callback),
	setScrollingFrame = t.optional(t.callback),
	containerRef = t.table,
	isScrollingEnabled = t.boolean,
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
	gameGridSidePadding = t.number,
	stableContentWidth = t.optional(t.number),
	categorySelectorHeight = t.optional(t.number),
	topBarCategoriesScrollerPadding = t.optional(t.number),
	topBarCategoriesScrollerHeight = t.optional(t.number),
	backgroundTransparency = t.number
}
local v9 = if module18 then t.optional(t.boolean) else nil
v8.hasThemeBackground = v9
v8.hasTopBar = t.boolean

v8.hideGameStatsIXP = t.optional(t.boolean)
local v10 = if module16 then t.optional(t.boolean) else nil
v8.hideDropdown = v10

v8.navigation = t.optional(t.table)
v8.screenProps = t.optional(t.table)

v8.loggingProtocol = t.table
v8.networking = t.callback
v8.eventIngest = t.table
v8.analytics = t.table
v8.appAnalytics = t.table
extended.validateProps = strictInterface(v8)

function extended:init()
	function self.isOmni()
		return self.state.selectedOmni
	end

	self.gamesListViewChangedSignal = signal.new()
	self.containerRef = self.props.containerRef
	function self.setContainerRef(current)
		self.containerRef.current = current

		if self.props.setScrollingFrame then
			self.props.setScrollingFrame(current)
		end
	end

	local screenSize = self.props.screenSize
	local gameGridSidePadding = self.props.gameGridSidePadding
	local v11

	if self.props.stableContentWidth then
		v11 = self.props.stableContentWidth
	else
		v11 = screenSize.X - 2 * gameGridSidePadding
	end

	if v11 < 0 then
		if defineFastFlag then
			if Workspace.CurrentCamera then
				local viewportSize = Workspace.CurrentCamera.ViewportSize
				mutedError(`See All contentWidth should be positive. screenSize.X: {screenSize.X}; sidePadding: {gameGridSidePadding}; Camera: ({viewportSize.X}, {viewportSize.Y})`)
			else
				mutedError(`See All does not have a Workspace.CurrentCamera! screenSize.X: {screenSize.X}; sidePadding: {gameGridSidePadding}`)
			end
		end

		v11 = 0
	end

	local v13 = if self.props.isOmni then self.props.initialSortIndex else nil
	self:setState({
		sortIndex = v13,
		sortName = self.props.initialSortName,
		selectedOmni = self.props.isOmni,
		contentSize = Vector2.new(v11, screenSize.Y),
		frameSize = screenSize
	})

	function self.getSelectedSort()
		return self.props.topicInfos[self.state.sortName] or {}
	end

	function self.getSelectedSortContents()
		return self.props.gameSortContents[self.state.sortName]
	end

	function self.getSelectedSortIdentifier()
		return self.state.sortName
	end

	function self.isSponsoredSort(): boolean
		local selectedSort = self.getSelectedSort()

		if selectedSort and selectedSort:isSponsored() then
			return true
		end

		return false
	end

	function self.isSdui(): boolean
		local selectedSort = self.getSelectedSort()

		if selectedSort and isSduiGameOmniFeedItem(selectedSort.treatmentType, selectedSort.topicId) then
			return true
		end

		return false
	end

	function self.refresh()
		local v14 = v6

		return self.isOmni()
			and self.props.dispatchRefreshOmni(
				self.props.networking,
				self.props.omniRecommendationsRequest,
				v14.OMNI_HOME.sortType,
				omniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh,
				self.props.loggingProtocol
			)
			or self.props.dispatchRefresh(self.props.networking, self.state.sortName, v14.GAMES.sortType)
	end

	function self.loadMoreGames(p2)
		local v14 = p2 or module3.Constants.DEFAULT_GAME_FETCH_COUNT
		local dispatchLoadMoreGames = self.props.dispatchLoadMoreGames
		local networking = self.props.networking
		local selectedSort = self.getSelectedSort()
		local selectedSortContents = self.getSelectedSortContents()

		if self.isOmni() then
			return self.props.dispatchLoadMoreGamesOmni(
				networking,
				v6.OMNI_HOME.sortType,
				self.state.sortIndex,
				v14,
				self.props.loggingProtocol
			)
		end

		if selectedSortContents then
			return dispatchLoadMoreGames(
				networking,
				selectedSort,
				selectedSortContents.rowsRequested,
				v14,
				selectedSortContents.nextPageExclusiveStartId,
				selectedSortContents.nextPageToken
			)
		end
	end

	function self.switchToSort(data, p2, p3)
		if not self.isMounted then
			return
		end

		if data.topicId == nil then
			self.props.analytics.reportFilterChangeWithId(data.gameSetTypeId, data.gameSetTargetId, p3)
			self:setState({ sortName = data.name, selectedOmni = false })
		else
			self.props.analytics.reportFilterChangeWithId(data.topicId, nil, p3)
			self:setState({
				sortIndex = p2,
				selectedOmni = true,
				sortName = tostring(data.topicId)
			})
		end

		spawn(function()
			if self.isMounted then
				self:setState({ forceRender = nil })
			end
		end)
	end

	function self.reportGameDetailOpened(p2)
		local selectedSort = self.getSelectedSort()
		local analytics = self.props.analytics

		local selectedSortContents = self.getSelectedSortContents()
		local entries = selectedSortContents and selectedSortContents.entries or nil

		if not entries then
			return
		end

		local analyticsTypeId = if selectedSort then selectedSort.analyticsTypeId or nil else nil
		local v14 = #entries
		local entry = entries[p2]
		local placeId = entry.placeId
		local isSponsored = entry.isSponsored
		local adId = entry.adId
		local gameSetTargetId = selectedSort and selectedSort.gameSetTargetId

		local universeId = entry.universeId
		local pageContext = self.props.pageContext
		local appliedFilters = selectedSort and selectedSort.appliedFilters or nil

		analytics.reportOpenGameDetailWithId(
			placeId,
			analyticsTypeId,
			gameSetTargetId,
			nil,
			p2,
			v14,
			isSponsored,
			adId,
			universeId,
			pageContext,
			appliedFilters,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			1
		)
	end

	function self.sendGameImpressionsFromSdui(p2, p3, p4, p5, p6)
		self.sendGameImpressions(p2, p3, p6)
	end

	function self.setLogSduiImpressions(p2)
		self:setState({ logSduiImpressions = p2 })
	end

	function self.onCollectionViewabilityChanged()
		self.gamesListViewChangedSignal:fire()
	end

	function self.sendGameImpressions(p2, p3, p4)
		local selectedSortContents = self.getSelectedSortContents()

		if not (p3 or selectedSortContents) then
			return
		end

		local selectedSort = self.getSelectedSort()

		if not selectedSort then
			return
		end

		local analyticsTypeId = selectedSort.analyticsTypeId
		local gameSetTargetId = selectedSort.gameSetTargetId

		local sortPageId = if not self.isOmni() then self.props.sortPageId else nil

		local appliedFilters = selectedSort.appliedFilters

		local pageContext = self.props.pageContext

		sendGameImpressions.sendFromSeeAll(
			self.props.eventIngest,
			self.props.appAnalytics,
			p2,
			p3 or selectedSortContents.entries,
			pageContext,
			analyticsTypeId,
			gameSetTargetId,
			sortPageId,
			appliedFilters,
			p4
		)
	end

	function self.onAbsoluteContentSizeChanged(p2)
		if self.props.stableContentWidth then
			return
		end

		if self.isMounted and p2 then
			local absoluteContentSize = p2.AbsoluteContentSize

			if self.state.contentSize == absoluteContentSize then
				return
			end

			if absoluteContentSize.X > 0 and absoluteContentSize.Y > 0 then
				self:setState({ contentSize = absoluteContentSize })
			end
		end
	end

	function self.updateGamesInSort()
		self.props.dispatchFetchExpiringTokens(self.props.networking, v6.GAMES.sortType)

		local selectedSortContents = self.getSelectedSortContents()
		local v15 = selectedSortContents
			and selectedSortContents.entries
			and #selectedSortContents.entries
			or nil

		if v15 ~= nil and v15 == 0 then
			if self.isOmni() then
				self.loadMoreGames():catch(function()
					warn("Failed to load omni games")
				end)
			else
				self.props.dispatchRefreshSortContents(self.props.networking, self.state.sortName)
			end
		end
	end

	function self.reportExperienceLaunched(data, p2, p3, p4, p5, actionType)
		local selectedSort = self.getSelectedSort()
		local eventIngest = self.props.eventIngest
		local experienceTile = context.ExperienceTile
		local v15 = {
			placeId = data.placeId,
			rootPlaceId = tonumber(data.placeId),
			universeId = data.universeId,
			sortIndex = tostring(self.state.sortIndex),
			sortEntryIndex = tostring(data.index),
			referralSource = p2,
			gameSetTypeId = 0,
			gameSetTargetId = 0,
			appliedFilters = 0,
			nativeAdData = 0,
			pageName = 0,
			tileType = 0,
			actionType = 0
		}

		local v16 = if self.isOmni() then selectedSort.topicId else selectedSort.gameSetTypeId
		v15.gameSetTypeId = v16
		local v17 = if not self.isOmni() then selectedSort.gameSetTargetId else nil
		v15.gameSetTargetId = v17
		v15.appliedFilters = selectedSort.appliedFilters
		v15.nativeAdData = data.adId
		v15.pageName = self.props.pageContext
		v15.tileType = gameCollectionItemTypes.GameCollectionItemType.GameTile

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v15.actionType = actionType
		gamePlayIntent(eventIngest, experienceTile, v15)
	end

	function self.onActivateTooltip()
		if self.isMounted and self.isSponsoredSort() then
			self.props.onActivateTooltip(self.props.sponsoredTooltipTitle, self.props.sponsoredTooltipBody)
		end
	end
end

function extended:renderWithLocalized(p2)
	local v11 = self.props.topBarHeight
	local selectedSortIdentifier = self.getSelectedSortIdentifier()
	local screenSize = self.props.screenSize
	local frameSize = self.state.frameSize
	local contentSize = self.state.contentSize
	local selectedSort = self.getSelectedSort()
	local selectedSortContents = self.getSelectedSortContents()
	local useCreationCenterTitle = self.props.useCreationCenterTitle
	local gameGridSidePadding = self.props.gameGridSidePadding
	local shouldHideGameStats = module14.shouldHideGameStats(
		self.props.pageContext,
		self.props.hideGameStatsIXP
	)
	local v12 = self.props.useCategoryScrollList and "Tabs" or "Dropdown"

	if not (selectedSortIdentifier and selectedSortContents) then
		return nil
	end

	local v13 = nil

	if useCreationCenterTitle then
		v13 = p2.creationCenter
	elseif self.props.pageContext == appPage.Games then
		v13 = p2.chartsTitle
	end

	local v14 = module15 and (not module16 or self.props.hideDropdown)
	local v15 = not v14 and 38 or nil
	local v16 = 12

	local v17 = if v14 then v16 else v15 + v16
	local v18 = v17 + SECTION_HEADER_HEIGHT + 14

	if v12 == "Tabs" then
		v11 = self.props.topBarCategoriesScrollerHeight
		v16 = 0
		v15 = 0
	end

	local v19 = v6

	local sponsoredSort = self.isSponsoredSort()
	local sponsoredTooltipBody = self.props.sponsoredTooltipBody

	local sdui = self.isSdui()

	return withStyle(function(props)
		local footer = gameTileConstants.PlayerCountStyleValues.Footer

		local v20 = Roact.createElement(
			"Frame",
			{
				Name = "TitleWithTooltip",
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0, 0, 0, v17),
				BackgroundTransparency = 1
			},
			{
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				Title = Roact.createElement("TextLabel", {
					Text = selectedSort.displayName,
					FontFace = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font),
					TextSize = props.Font.BaseSize * props.Font.Header1.RelativeSize,
					TextColor3 = props.Theme.TextEmphasis.Color,
					TextTransparency = props.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = 1
				}),
				GamesListTooltip = Roact.createElement(iconWithTooltip, {
					tooltipOrientation = tooltipOrientation.Bottom,
					onActivateTooltip = self.onActivateTooltip,
					layoutOrder = 2,
					hoverText = sponsoredTooltipBody,
					triggerPointName = "GamesListTooltip"
				})
			}
		)

		local createElement = Roact.createElement
		local v22 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = self.props.backgroundTransparency,
			BorderSizePixel = 0
		}

		local v24 = if self.props.hasTopBar then Roact.createElement(module10, {
			titleText = v13,
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0
		}) else nil
		local v25

		if v12 == "Tabs" then
			local createElement2 = Roact.createElement
			local headersByTag = {
				[React.Tag] = compositionTags.ContentRegion.Header,
				Size = UDim2.new(1, 0, 0, self.props.categorySelectorHeight),
				ZIndex = 2,
				BackgroundColor3 = props.Theme.BackgroundDefault.Color,
				BackgroundTransparency = self.props.backgroundTransparency
			}

			local v28 = if self.props.hasThemeBackground then Roact.createElement(module19.ThemeBackgroundHeaderSlot) else nil
			v25 = createElement2("Frame", headersByTag, {
				ThemeBackgroundSlot = v28,
				GameCategoryTabGroup = Roact.createElement(module7, {
					size = UDim2.new(1, 0, 0, self.props.categorySelectorHeight),
					sortCategories = v19,
					selectedSortIndex = self.state.sortIndex,
					selectedSortName = selectedSortIdentifier,
					onSelected = self.switchToSort,
					padding = { left = 0, right = 0, top = 0, bottom = 0 }
				})
			})
		end

		local createElement2 = Roact.createElement
		local v27 = if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then UDim2.fromOffset(0, 0) else UDim2.new(0, 0, 0, v11)
		local v28 = if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 1, -v11)
		local setContainerRefsByRef = {
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			Position = v27,
			Size = v28,
			BackgroundTransparency = self.props.backgroundTransparency,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			refresh = self.refresh,
			onLoadMore = selectedSortContents.hasMoreRows and self.loadMoreGames,
			ScrollingEnabled = self.props.isScrollingEnabled,
			createEndOfScrollElement = not selectedSortContents.hasMoreRows
		}
		local v29 = if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then v11 else nil
		setContainerRefsByRef.canvasTopPadding = v29

		setContainerRefsByRef.canvasSidePadding = if fFlagLuaAppLayoutParamsInContext then gameGridSidePadding else nil
		local v31 = if fFlagLuaAppLayoutParamsInContext then self.props.setContentFrame else nil
		setContainerRefsByRef.contentFrameRefCallback = v31
		local v32 = if fFlagLuaAppSduiSeeAllLayoutParamsFix then Enum.AutomaticSize.Y else nil
		setContainerRefsByRef.AutomaticCanvasSize = v32
		function setContainerRefsByRef.onAbsoluteSizeChangedCallback(p3)
			if self.isMounted and p3 then
				self:setState({ frameSize = p3.AbsoluteSize })
			end

			self.gamesListViewChangedSignal:fire()
		end
		function setContainerRefsByRef.onCanvasPositionChangedCallback()
			self.gamesListViewChangedSignal:fire()
		end
		setContainerRefsByRef.shouldExtendIntoSafeArea = fFlagExtendScrollingFramesBySafeInsets
			and { left = false, top = false, right = false, bottom = true }
			or nil

		setContainerRefsByRef.contentTag = compositionTags.ContentRegion.Body
		setContainerRefsByRef[Roact.Ref] = self.setContainerRef
		local children = {
			["Layout"] = nil,
			["Layout"] = nil,
			["Layout"] = nil,
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = self.onAbsoluteContentSizeChanged
			}),
			PaddingTopSpacer = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, GAME_GRID_PADDING),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		}
		local v33

		if v12 == "Dropdown" then
			local createElement4 = Roact.createElement
			local v35 = {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v18),
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local v36 = {
				Padding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v16)
				}),
				DropDown = 0,
				Title = 0
			}

			local v37 = if not v14 then Roact.createElement(module6, {
				size = UDim2.new(1, 0, 0, v15),
				position = UDim2.new(0, 0, 0, 0),
				selectedSortName = selectedSortIdentifier,
				selectedSortIndex = self.state.sortIndex,
				onSelected = self.switchToSort,
				isOmni = self.isOmni(),
				sortCategories = v19
			}) else nil
			v36.DropDown = v37

			if not sponsoredSort then
				v20 = Roact.createElement(fitTextLabel, {
					Text = selectedSort.displayName,
					Position = UDim2.new(0, 0, 0, v17),
					Font = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font),
					TextSize = props.Font.BaseSize * props.Font.Header1.RelativeSize,
					TextColor3 = props.Theme.TextEmphasis.Color,
					TextTransparency = props.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					width = UDim.new(1, 0),
					TextWrapped = true
				})
			end

			v36.Title = v20
			v33 = createElement4("Frame", v35, v36)
		end

		children.TopSection = v33

		local v34 = "GameGrid " .. selectedSortIdentifier
		local v35

		if sdui then
			local createElement4 = React.createElement
			local v37 = {
				appPage = self.props.pageContext,
				verticalScrollingFrameRef = self.containerRef,
				contentFrame = 0,
				scrollViewPositionChangedSignal = 0,
				collectionId = 0,
				collectionIndex = 0,
				layoutOrder = 2,
				impressionsTag = "GamesList",
				setLogImpressions = 0,
				sendGameImpressions = 0,
				onCollectionViewabilityChanged = 0
			}
			local v38 = if fFlagLuaAppLayoutParamsInContext then self.props.contentFrame else nil
			v37.contentFrame = v38
			v37.scrollViewPositionChangedSignal = self.gamesListViewChangedSignal
			v37.collectionId = self.state.sortName
			v37.collectionIndex = self.state.sortIndex

			v37.setLogImpressions = self.setLogSduiImpressions
			v37.sendGameImpressions = self.sendGameImpressionsFromSdui
			v37.onCollectionViewabilityChanged = self.onCollectionViewabilityChanged
			v35 = createElement4(sduiSeeAllGrid, v37)
		else
			local createElement4 = Roact.createElement
			local v37 = {
				LayoutOrder = 2,
				entries = selectedSortContents.entries,
				reportGameDetailOpened = self.reportGameDetailOpened,
				windowSize = 0,
				screenSize = 0,
				hideGameStats = 0,
				currentSidePadding = 0,
				impressionsTag = "GamesList",
				reportExperienceLaunched = 0,
				launchExperienceEventContext = 0,
				playerCountStyle = 0,
				appCompositionEnabled = true
			}
			local v38 = if self.props.stableContentWidth then Vector2.new(self.props.stableContentWidth, frameSize.Y) else Vector2.new(contentSize.X, frameSize.Y)
			v37.windowSize = v38

			v37.screenSize = screenSize
			v37.hideGameStats = shouldHideGameStats
			v37.currentSidePadding = gameGridSidePadding

			v37.reportExperienceLaunched = self.reportExperienceLaunched
			v37.launchExperienceEventContext = context.ExperienceTile
			v37.playerCountStyle = footer
			v35 = createElement4(gameGridSelector, v37)
		end

		children[v34] = v35

		local createElement4 = Roact.createElement
		local v37 = {
			parentRef = self.containerRef,
			impressionsTag = "GamesList",
			scrollViewPositionChangedSignal = self.gamesListViewChangedSignal,
			sendGameImpressions = 0,
			gameSortId = 0
		}
		local v38 = if sdui then self.state.logSduiImpressions else self.sendGameImpressions
		v37.sendGameImpressions = v38
		v37.gameSortId = self.state.sortName
		children.GameSeeAllImpressionsDetector = createElement4(module13, v37)
		return createElement("Frame", v22, {
			TopBar = v24,
			CategorySelectorScrollWrapper = v25,
			Scroller = createElement2(module8, setContainerRefsByRef, children)
		})
	end)
end

function extended:render()
	return withLocalization({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		chartsTitle = "CommonUI.Features.Label.Charts"
	})(function(p2)
		return self:renderWithLocalized(p2)
	end)
end

function extended:didMount()
	self.isMounted = true

	if
		fFlagLuaAppSortDeeplinkFix
		or self.props.pageContext ~= "Deeplink"
		or self.props.gameSortContents[self.state.sortName]
	then
		self.updateGamesInSort()
	else
		self.props.dispatchFetchExpiringTokens(self.props.networking, v6.GAMES.sortType):andThen(function()
			if self.isMounted then
				self:setState({ missingSortLoadComplete = true })
			end
		end, function(p2)
			default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter)
			self.props.navigateBack()
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.didUpdate(object, p2, p3)
	if
		object.state.sortName ~= p3.sortName
		or not fFlagLuaAppSortDeeplinkFix
		and not p2.gameSortContents[object.state.sortName]
		and object.props.gameSortContents[object.state.sortName]
	then
		if not fFlagLuaAppSortDeeplinkFix then
			task.spawn(function()
				if object.isMounted then
					object:setState({ missingSortLoadComplete = false })
				end
			end)
		end

		object.updateGamesInSort()
	end

	if
		not fFlagLuaAppSortDeeplinkFix
		and object.state.missingSortLoadComplete
		and not object.props.gameSortContents[object.state.sortName]
	then
		default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter)
		object.props.navigateBack()
	end
end

local v11 = RoactRodux.connect(function(data, p2)
	return {
		topBarHeight = data.TopBar.topBarHeight,
		screenSize = data.ScreenSize,
		topicInfos = data.Personalization[topicInfosReducer.key],
		gameSortContents = data.Personalization[topicContentsReducer.key]
	}
end, function(callback)
	return {
		dispatchRefresh = function(p2, p3, p4)
			if fFlagUseSignalsForSiteMessage then
				getSiteMessageStore(false).refreshSiteAlertInfo()
			else
				callback(module9())
			end

			return callback(fetchDataWithErrorToasts(refreshGameSorts(p2, { p4 }, p3, nil)))
		end,
		dispatchRefreshOmni = function(p2, p3, p4, p5, p6)
			if fFlagUseSignalsForSiteMessage then
				getSiteMessageStore(false).refreshSiteAlertInfo()
			else
				callback(module9())
			end

			return callback(fetchDataWithErrorToasts(apiFetchOmniRecommendations(p2, p3, p4, nil, nil, p5, p6)))
		end,
		dispatchRefreshSortContents = function(p2, p3)
			return callback(apiFetchGamesData(p2, nil, p3, nil, nil))
		end,
		dispatchLoadMoreGames = function(p2, p3, p4, p5, p6, p7)
			return callback(fetchDataWithErrorToasts(apiFetchGamesInSort(p2, p3, true, {
				startRows = p4,
				maxRows = p5,
				exclusiveStartId = p6,
				pageToken = p7
			})))
		end,
		dispatchLoadMoreGamesOmni = function(p2, p3, p4, p5, p6)
			return callback(fetchDataWithErrorToasts(apiFetchOmniRecommendationsMetadata(
				p2,
				p3,
				p4,
				p5,
				p6,
				fFlagLuaAppLogOmniRecommendationsMetadata and "GamesList" or nil
			)))
		end,
		dispatchFetchExpiringTokens = function(p2, p3)
			return callback(refreshExpiringSortTokens(p2, { p3 }))
		end,
		navigateBack = function()
			return callback(navigateBack())
		end
	}
end)(extended)

local v12 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.GameTileLayer, appUserLayers.PlayerAppSeeAllUXLayer },
	function(p2, p3)
		local v13 = p2[appUserLayers.GameTileLayer] or {}
		local v14 = p2[appUserLayers.PlayerAppSeeAllUXLayer] or {}

		local v15 = {
			hideGameStatsIXP = v13.hideGameStats == "true",
			hideDropdown = 0
		}

		local v16 = if module16 then v14.ShouldRemoveSeeAllDropdown else nil
		v15.hideDropdown = v16
		return v15
	end
)(function(props)
	local v13 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})

	local sponsoredDisclosure = v13.SponsoredDisclosure
	local sponsoredTitle = v13.SponsoredTitle
	local v14 = useDispatch()
	local v15 = React.useCallback(function(p2, p3)
		v14(openInfoPeekView(p2, p3))
	end, {})

	local v16 = useDeviceType()

	local v17 = useNavigationProps(function(p2, data)
		local v18 = {
			sortPageId = data.sortPageId,
			pageContext = data.pageContext,
			pageTimer = data.pageTimer,
			initialSortName = p2
		}

		if data.isOmni then
			v18.isOmni = true
			v18.initialSortIndex = data.sortIndex
		end

		return v18
	end)

	local v18 = useAppPolicy(function(p2)
		return p2.getGamesPageCreationCenterTitle()
	end)

	local v19 = useAppPolicy(function(p2)
		return p2.getGameListCategoryScrollListEnabled()
	end)

	local v20 = useDesignTokens()

	local v21 = if module18 then module19.useThemeBackground() ~= nil else false

	local v22 = useUiModeInfo().uiMode ~= uiMode.TenFoot

	local state, setState = React.useState(nil)

	local v23 = useCollectionLayout()

	local v24 = math.max(0, SignalsReact.useSignalState(v23.getContainerWidth) - 2 * v23.margin)
	local state2, setState2

	if fFlagLuaAppLayoutParamsInContext then
		state2, setState2 = React.useState(nil)
	end

	local ref = React.useRef(nil)
	local v25 = useLastInputMode() == "Cursor"
	useAnimateScrollViewToSelection(ref, 0.4)

	local v26 = not (v17.isOmni or props.isOmni)

	if fFlagLuaAppLogChartsAppPageExposure then
		module12(v26)
	end

	if v26 then
		return React.createElement(module11, {
			sortId = v17.initialSortName or props.initialSortName,
			pageContext = v17.pageContext or props.pageContext,
			pageTimer = v17.pageTimer
		})
	end

	if fFlagLuaAppEnableSduiHomePage and (v17.isOmni or props.isOmni) then
		local pageContext = v17.pageContext or props.pageContext
		local initialSortName = v17.initialSortName or props.initialSortName
		local initialSortIndex = v17.initialSortIndex or props.initialSortIndex
		return React.createElement(v5, {
			sortId = initialSortName,
			sortIndex = initialSortIndex,
			pageContext = pageContext
		})
	else
		local join = Cryo.Dictionary.join
		local v27 = {
			deviceType = v16,
			onActivateTooltip = v15,
			sponsoredTooltipBody = sponsoredDisclosure,
			sponsoredTooltipTitle = sponsoredTitle,
			useCreationCenterTitle = v18,
			useCategoryScrollList = v19,
			categorySelectorHeight = v20.Size.Size_1200,
			topBarCategoriesScrollerHeight = v20.Size.Size_2000,
			topBarCategoriesScrollerPadding = v20.Size.Size_400,
			hasTopBar = v22,
			backgroundTransparency = v21 and 1 or v20.LuaApps.SeeAll.BackgroundTransparency,
			hasThemeBackground = 0,
			safeAreaPadding = 0,
			gameGridSidePadding = 0,
			stableContentWidth = 0,
			contentFrame = 0,
			setContentFrame = 0,
			setScrollingFrame = 0,
			containerRef = 0,
			isScrollingEnabled = 0
		}

		if not module18 then
			v21 = nil
		end

		v27.hasThemeBackground = v21
		v27.safeAreaPadding = v20.Size.Size_1600

		v27.stableContentWidth = v24

		if not fFlagLuaAppLayoutParamsInContext then
			state2 = nil
		end

		v27.contentFrame = state2

		if not fFlagLuaAppLayoutParamsInContext then
			setState2 = nil
		end

		v27.setContentFrame = setState2
		v27.setScrollingFrame = setState
		v27.containerRef = ref
		v27.isScrollingEnabled = v25
		local v28 = join(props, v27, v17)

		return Roact.createElement(v11, v28)
	end
end)

return roactServices.connect({
	networking = roactNetworking,
	eventIngest = appEventIngestService,
	analytics = roactAnalyticsCommonGameEvents,
	appAnalytics = roactAnalytics,
	loggingProtocol = appLogging
})(v12)
