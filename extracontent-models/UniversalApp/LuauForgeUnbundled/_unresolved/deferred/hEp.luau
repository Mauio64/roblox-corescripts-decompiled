local Workspace = game:GetService("Workspace")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local topicInfosReducer = require("@luauforge/bundled/dzL").TopicInfosReducer
local topicContentsReducer = require("@luauforge/bundled/dzJ").TopicContentsReducer
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
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local gameCollectionItemTypes = require("@luauforge/deferred/gao").GameCollectionItemTypes
local sendGameImpressions = require("@luauforge/deferred/gao").SendGameImpressions
local module2 = require("@luauforge/bundled/dwD")
local gamePlayIntent = module2.Events.gamePlayIntent
local sortDeeplinkFailureCounter = module2.Events.sortDeeplinkFailureCounter
local context = module2.Constants.Context
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useDeviceType = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useDeviceType
local useNavigationProps = require("@luauforge/bundled/dCu").useNavigationProps
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/AppBlox").IconWithTooltip
local openInfoPeekView = require("@luauforge/bundled/fXq").OpenInfoPeekView
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module3 = require("@luauforge/bundled/cyO")
local gameSortGroups = module3.GameSortGroups
local omniFeedConstants = module3.OmniFeedConstants
local gameTileConstants = require("@luauforge/bundled/fYU").GameTileConstants
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local sduiSeeAllGrid = require("@luauforge/bundled/dAU").SduiSeeAllGrid
local isSduiGameOmniFeedItem = require("@luauforge/bundled/dAU").isSduiGameOmniFeedItem
local module4 = require("@luauforge/bundled/dHu")
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/AppBlox").useAnimateScrollViewToSelection
local useLastInputMode = require("@luauforge/bundled/eeo").useLastInputMode

local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local modules = require("@luauforge/bundled/dpZ").Modules
local apiFetchGamesInSort = modules.LuaApp.Thunks.Games.ApiFetchGamesInSort
local fetchDataWithErrorToasts = modules.LuaApp.Thunks.FetchDataWithErrorToasts
local apiFetchOmniRecommendationsMetadata = modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendationsMetadata
local apiFetchOmniRecommendations = modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations
local gameGridSelector = modules.LuaApp.Components.Games.GameGridSelector
local apiFetchGamesData = modules.LuaApp.Thunks.Games.ApiFetchGamesData
local refreshGameSorts = modules.LuaApp.Thunks.RefreshGameSorts
local refreshExpiringSortTokens = modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useCollectionLayout = require("@luauforge/bundled/edJ").useCollectionLayout
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local module5 = require("@luauforge/bundled/dwA")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local module7 = require("@luauforge/bundled/hEq")
local module8 = require("@luauforge/deferred/hEA")
local module9 = require("@luauforge/bundled/edf")
local module10 = require("@luauforge/bundled/dwI")
local getSiteMessageStore = require("@luauforge/bundled/frA").GetSiteMessageStore
local module11 = require("@luauforge/bundled/hEB")
local module12 = require("@luauforge/deferred/hEG")
local module13 = require("@luauforge/deferred/hEI")
local module14 = require("@luauforge/deferred/hEK")
local module15 = require("@luauforge/deferred/hEL")

local module16 = require("@luauforge/deferred/hEM")
local module17 = require("@luauforge/deferred/hEN")

local defineFastFlag = game:DefineFastFlag("LuaAppExplicitErrorOnWidthForSeeAll2", false)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForSiteMessage = SharedFlags.FFlagUseSignalsForSiteMessage

local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local v6 = if SharedFlags.FFlagLuaAppSduiHomePageSupport then require("@luauforge/deferred/hEO") else nil

local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppSortDeeplinkFix = SharedFlags.FFlagLuaAppSortDeeplinkFix
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppSduiSeeAllLayoutParamsFix = SharedFlags.FFlagLuaAppSduiSeeAllLayoutParamsFix
local fFlagLuaAppLogOmniRecommendationsMetadata = SharedFlags.FFlagLuaAppLogOmniRecommendationsMetadata
local fFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local fFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local fFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry

local module19 = require("@luauforge/bundled/hEJ")
local module20 = require("@luauforge/bundled/eeu")

local GAME_GRID_PADDING = module3.Constants.GAME_GRID_PADDING
local SECTION_HEADER_HEIGHT = module5.SECTION_HEADER_HEIGHT

local v7 = {
	OMNI_HOME = { sortType = appPage.Home, isOmni = true },
	GAMES = { sortType = gameSortGroups.GamesList, isOmni = false }
}

local v8 = { Dropdown = "Dropdown", Tabs = "Tabs" }

local extended = Roact.PureComponent:extend("GamesList")

local strictInterface = t.strictInterface
local v9 = {
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
local v10 = if module19 then t.optional(t.boolean) else nil
v9.hasThemeBackground = v10
v9.hasTopBar = t.boolean

v9.hideGameStatsIXP = t.optional(t.boolean)
local v11 = if module17 then t.optional(t.boolean) else nil
v9.hideDropdown = v11

v9.navigation = t.optional(t.table)
v9.screenProps = t.optional(t.table)

v9.loggingProtocol = t.table
v9.networking = t.callback
v9.eventIngest = t.table
v9.analytics = t.table
v9.appAnalytics = t.table
extended.validateProps = strictInterface(v9)

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
	local v12

	if self.props.stableContentWidth then
		v12 = self.props.stableContentWidth
	else
		v12 = screenSize.X - 2 * gameGridSidePadding
	end

	if v12 < 0 then
		if defineFastFlag then
			if Workspace.CurrentCamera then
				local viewportSize = Workspace.CurrentCamera.ViewportSize
				mutedError(`See All contentWidth should be positive. screenSize.X: {screenSize.X}; sidePadding: {gameGridSidePadding}; Camera: ({viewportSize.X}, {viewportSize.Y})`)
			else
				mutedError(`See All does not have a Workspace.CurrentCamera! screenSize.X: {screenSize.X}; sidePadding: {gameGridSidePadding}`)
			end
		end

		v12 = 0
	end

	local v14 = if self.props.isOmni then self.props.initialSortIndex else nil
	self:setState({
		sortIndex = v14,
		sortName = self.props.initialSortName,
		selectedOmni = self.props.isOmni,
		contentSize = Vector2.new(v12, screenSize.Y),
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
		local v15 = v7

		return self.isOmni()
			and self.props.dispatchRefreshOmni(
				self.props.networking,
				self.props.omniRecommendationsRequest,
				v15.OMNI_HOME.sortType,
				omniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh,
				self.props.loggingProtocol
			)
			or self.props.dispatchRefresh(self.props.networking, self.state.sortName, v15.GAMES.sortType)
	end

	function self.loadMoreGames(p2)
		local v15 = p2 or module3.Constants.DEFAULT_GAME_FETCH_COUNT
		local dispatchLoadMoreGames = self.props.dispatchLoadMoreGames
		local networking = self.props.networking
		local selectedSort = self.getSelectedSort()
		local selectedSortContents = self.getSelectedSortContents()

		if self.isOmni() then
			return self.props.dispatchLoadMoreGamesOmni(
				networking,
				v7.OMNI_HOME.sortType,
				self.state.sortIndex,
				v15,
				self.props.loggingProtocol
			)
		end

		if selectedSortContents then
			return dispatchLoadMoreGames(
				networking,
				selectedSort,
				selectedSortContents.rowsRequested,
				v15,
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
		local v15 = #entries
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
			v15,
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
		self.props.dispatchFetchExpiringTokens(self.props.networking, v7.GAMES.sortType)

		local selectedSortContents = self.getSelectedSortContents()
		local v16 = selectedSortContents
			and selectedSortContents.entries
			and #selectedSortContents.entries
			or nil

		if v16 ~= nil and v16 == 0 then
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
		local v16 = {
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

		local v17 = if self.isOmni() then selectedSort.topicId else selectedSort.gameSetTypeId
		v16.gameSetTypeId = v17
		local v18 = if not self.isOmni() then selectedSort.gameSetTargetId else nil
		v16.gameSetTargetId = v18
		v16.appliedFilters = selectedSort.appliedFilters
		v16.nativeAdData = data.adId
		v16.pageName = self.props.pageContext
		v16.tileType = gameCollectionItemTypes.GameCollectionItemType.GameTile

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v16.actionType = actionType
		gamePlayIntent(eventIngest, experienceTile, v16)
	end

	function self.onActivateTooltip()
		if self.isMounted and self.isSponsoredSort() then
			self.props.onActivateTooltip(self.props.sponsoredTooltipTitle, self.props.sponsoredTooltipBody)
		end
	end
end

function extended:renderWithLocalized(p2)
	local v12 = self.props.topBarHeight
	local selectedSortIdentifier = self.getSelectedSortIdentifier()
	local screenSize = self.props.screenSize
	local frameSize = self.state.frameSize
	local contentSize = self.state.contentSize
	local selectedSort = self.getSelectedSort()
	local selectedSortContents = self.getSelectedSortContents()
	local useCreationCenterTitle = self.props.useCreationCenterTitle
	local gameGridSidePadding = self.props.gameGridSidePadding
	local shouldHideGameStats = module15.shouldHideGameStats(
		self.props.pageContext,
		self.props.hideGameStatsIXP
	)
	local v13 = self.props.useCategoryScrollList and "Tabs" or "Dropdown"

	if not (selectedSortIdentifier and selectedSortContents) then
		return nil
	end

	local v14 = nil

	if useCreationCenterTitle then
		v14 = p2.creationCenter
	elseif self.props.pageContext == appPage.Games then
		v14 = p2.chartsTitle
	end

	local v15 = module16 and (not module17 or self.props.hideDropdown)
	local v16 = not v15 and 38 or nil
	local v17 = 12

	local v18 = if v15 then v17 else v16 + v17
	local v19 = v18 + SECTION_HEADER_HEIGHT + 14

	if v13 == "Tabs" then
		v12 = self.props.topBarCategoriesScrollerHeight
		v17 = 0
		v16 = 0
	end

	local v20 = v7

	local sponsoredSort = self.isSponsoredSort()
	local sponsoredTooltipBody = self.props.sponsoredTooltipBody

	local sdui = self.isSdui()

	return withStyle(function(props)
		local footer = gameTileConstants.PlayerCountStyleValues.Footer

		local createElement = Roact.createElement
		local v22 = {
			Name = "TitleWithTooltip",
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0, 0, 0, v18),
			BackgroundTransparency = 1
		}

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			Title = 0,
			GamesListTooltip = 0
		}

		local createElement2 = Roact.createElement
		local v24 = {
			Text = selectedSort.displayName,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1
		}
		local v25 = if not foundationFontFaceMigration then props.Font.Header1.Font else nil
		v24.Font = v25

		local v26 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font) else nil
		v24.FontFace = v26

		v24.TextSize = props.Font.BaseSize * props.Font.Header1.RelativeSize
		v24.TextColor3 = props.Theme.TextEmphasis.Color
		v24.TextTransparency = props.Theme.TextEmphasis.Transparency
		v24.TextXAlignment = Enum.TextXAlignment.Left
		v24.TextYAlignment = Enum.TextYAlignment.Top
		v24.AutomaticSize = Enum.AutomaticSize.XY
		children.Title = createElement2("TextLabel", v24)

		children.GamesListTooltip = Roact.createElement(iconWithTooltip, {
			tooltipOrientation = tooltipOrientation.Bottom,
			onActivateTooltip = self.onActivateTooltip,
			layoutOrder = 2,
			hoverText = sponsoredTooltipBody,
			triggerPointName = "GamesListTooltip"
		})
		local v27 = createElement("Frame", v22, children)

		local createElement3 = Roact.createElement
		local v29 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = self.props.backgroundTransparency,
			BorderSizePixel = 0
		}

		local v31 = if self.props.hasTopBar then Roact.createElement(module11, {
			titleText = v14,
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0
		}) else nil
		local v32

		if v13 == "Tabs" then
			local createElement4 = Roact.createElement
			local headersByTag = {
				[React.Tag] = compositionTags.ContentRegion.Header,
				Size = UDim2.new(1, 0, 0, self.props.categorySelectorHeight),
				ZIndex = 2,
				BackgroundColor3 = props.Theme.BackgroundDefault.Color,
				BackgroundTransparency = self.props.backgroundTransparency
			}

			local v35 = if self.props.hasThemeBackground then Roact.createElement(module20.ThemeBackgroundHeaderSlot) else nil
			v32 = createElement4("Frame", headersByTag, {
				ThemeBackgroundSlot = v35,
				GameCategoryTabGroup = Roact.createElement(module8, {
					size = UDim2.new(1, 0, 0, self.props.categorySelectorHeight),
					sortCategories = v20,
					selectedSortIndex = self.state.sortIndex,
					selectedSortName = selectedSortIdentifier,
					onSelected = self.switchToSort,
					padding = { left = 0, right = 0, top = 0, bottom = 0 }
				})
			})
		end

		local createElement4 = Roact.createElement
		local v34 = if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then UDim2.fromOffset(0, 0) else UDim2.new(0, 0, 0, v12)
		local v35 = if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 1, -v12)
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
			Position = v34,
			Size = v35,
			BackgroundTransparency = self.props.backgroundTransparency,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			refresh = self.refresh,
			onLoadMore = selectedSortContents.hasMoreRows and self.loadMoreGames,
			ScrollingEnabled = self.props.isScrollingEnabled,
			createEndOfScrollElement = not selectedSortContents.hasMoreRows
		}
		local v36 = if fFlagAppIaScrollAway and module4.getScrollAwayEnabled() then v12 else nil
		setContainerRefsByRef.canvasTopPadding = v36

		setContainerRefsByRef.canvasSidePadding = if fFlagLuaAppLayoutParamsInContext then gameGridSidePadding else nil
		local v38 = if fFlagLuaAppLayoutParamsInContext then self.props.setContentFrame else nil
		setContainerRefsByRef.contentFrameRefCallback = v38
		local v39 = if fFlagLuaAppSduiSeeAllLayoutParamsFix then Enum.AutomaticSize.Y else nil
		setContainerRefsByRef.AutomaticCanvasSize = v39
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
		local children2 = {
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
		local v40

		if v13 == "Dropdown" then
			local createElement6 = Roact.createElement
			local v42 = {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v19),
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local v43 = {
				Padding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v17)
				}),
				DropDown = 0,
				Title = 0
			}

			local v44 = if not v15 then Roact.createElement(module7, {
				size = UDim2.new(1, 0, 0, v16),
				position = UDim2.new(0, 0, 0, 0),
				selectedSortName = selectedSortIdentifier,
				selectedSortIndex = self.state.sortIndex,
				onSelected = self.switchToSort,
				isOmni = self.isOmni(),
				sortCategories = v20
			}) else nil
			v43.DropDown = v44

			if not sponsoredSort then
				local createElement7 = Roact.createElement
				local v46 = {
					Text = selectedSort.displayName,
					Position = UDim2.new(0, 0, 0, v18),
					Font = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					TextYAlignment = 0,
					BackgroundTransparency = 1,
					Size = 0,
					fitAxis = 0,
					width = 0,
					TextWrapped = true
				}

				local v47 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font) else props.Font.Header1.Font
				v46.Font = v47

				v46.TextSize = props.Font.BaseSize * props.Font.Header1.RelativeSize
				v46.TextColor3 = props.Theme.TextEmphasis.Color
				v46.TextTransparency = props.Theme.TextEmphasis.Transparency
				v46.TextXAlignment = Enum.TextXAlignment.Left
				v46.TextYAlignment = Enum.TextYAlignment.Top

				v46.Size = UDim2.new(1, 0, 0, 0)
				local v48 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
				v46.fitAxis = v48
				local v49 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
				v46.width = v49
				v27 = createElement7(v5, v46)
			end

			v43.Title = v27
			v40 = createElement6("Frame", v42, v43)
		end

		children2.TopSection = v40

		local v41 = "GameGrid " .. selectedSortIdentifier
		local v42

		if sdui then
			local createElement6 = React.createElement
			local v44 = {
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
			local v45 = if fFlagLuaAppLayoutParamsInContext then self.props.contentFrame else nil
			v44.contentFrame = v45
			v44.scrollViewPositionChangedSignal = self.gamesListViewChangedSignal
			v44.collectionId = self.state.sortName
			v44.collectionIndex = self.state.sortIndex

			v44.setLogImpressions = self.setLogSduiImpressions
			v44.sendGameImpressions = self.sendGameImpressionsFromSdui
			v44.onCollectionViewabilityChanged = self.onCollectionViewabilityChanged
			v42 = createElement6(sduiSeeAllGrid, v44)
		else
			local createElement6 = Roact.createElement
			local v44 = {
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
			local v45 = if self.props.stableContentWidth then Vector2.new(self.props.stableContentWidth, frameSize.Y) else Vector2.new(contentSize.X, frameSize.Y)
			v44.windowSize = v45

			v44.screenSize = screenSize
			v44.hideGameStats = shouldHideGameStats
			v44.currentSidePadding = gameGridSidePadding

			v44.reportExperienceLaunched = self.reportExperienceLaunched
			v44.launchExperienceEventContext = context.ExperienceTile
			v44.playerCountStyle = footer
			v42 = createElement6(gameGridSelector, v44)
		end

		children2[v41] = v42

		local createElement6 = Roact.createElement
		local v44 = {
			parentRef = self.containerRef,
			impressionsTag = "GamesList",
			scrollViewPositionChangedSignal = self.gamesListViewChangedSignal,
			sendGameImpressions = 0,
			gameSortId = 0
		}
		local v45 = if sdui then self.state.logSduiImpressions else self.sendGameImpressions
		v44.sendGameImpressions = v45
		v44.gameSortId = self.state.sortName
		children2.GameSeeAllImpressionsDetector = createElement6(module14, v44)
		return createElement3("Frame", v29, {
			TopBar = v31,
			CategorySelectorScrollWrapper = v32,
			Scroller = createElement4(module9, setContainerRefsByRef, children2)
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
		self.props.dispatchFetchExpiringTokens(self.props.networking, v7.GAMES.sortType):andThen(function()
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

local v12 = RoactRodux.connect(function(data, p2)
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
				callback(module10())
			end

			return callback(fetchDataWithErrorToasts(refreshGameSorts(p2, { p4 }, p3, nil)))
		end,
		dispatchRefreshOmni = function(p2, p3, p4, p5, p6)
			if fFlagUseSignalsForSiteMessage then
				getSiteMessageStore(false).refreshSiteAlertInfo()
			else
				callback(module10())
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

local v13 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.GameTileLayer, appUserLayers.PlayerAppSeeAllUXLayer },
	function(p2, p3)
		local v14 = p2[appUserLayers.GameTileLayer] or {}
		local v15 = p2[appUserLayers.PlayerAppSeeAllUXLayer] or {}

		local v16 = {
			hideGameStatsIXP = v14.hideGameStats == "true",
			hideDropdown = 0
		}

		local v17 = if module17 then v15.ShouldRemoveSeeAllDropdown else nil
		v16.hideDropdown = v17
		return v16
	end
)(function(props)
	local v14 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})

	local sponsoredDisclosure = v14.SponsoredDisclosure
	local sponsoredTitle = v14.SponsoredTitle
	local v15 = useDispatch()
	local v16 = React.useCallback(function(p2, p3)
		v15(openInfoPeekView(p2, p3))
	end, {})

	local v17 = useDeviceType()

	local v18 = useNavigationProps(function(p2, data)
		local v19 = {
			sortPageId = data.sortPageId,
			pageContext = data.pageContext,
			pageTimer = data.pageTimer,
			initialSortName = p2
		}

		if data.isOmni then
			v19.isOmni = true
			v19.initialSortIndex = data.sortIndex
		end

		return v19
	end)

	local v19 = useAppPolicy(function(p2)
		return p2.getGamesPageCreationCenterTitle()
	end)

	local v20 = useAppPolicy(function(p2)
		return p2.getGameListCategoryScrollListEnabled()
	end)

	local v21 = useDesignTokens()

	local v22 = if module19 then module20.useThemeBackground() ~= nil else false

	local v23 = useUiModeInfo().uiMode ~= uiMode.TenFoot

	local state, setState = React.useState(nil)

	local v24 = useCollectionLayout()

	local v25 = math.max(0, SignalsReact.useSignalState(v24.getContainerWidth) - 2 * v24.margin)
	local state2, setState2

	if fFlagLuaAppLayoutParamsInContext then
		state2, setState2 = React.useState(nil)
	end

	local ref = React.useRef(nil)
	local v26 = useLastInputMode() == "Cursor"
	useAnimateScrollViewToSelection(ref, 0.4)

	local v27 = not (v18.isOmni or props.isOmni)

	if fFlagLuaAppLogChartsAppPageExposure then
		module13(v27)
	end

	if v27 then
		return React.createElement(module12, {
			sortId = v18.initialSortName or props.initialSortName,
			pageContext = v18.pageContext or props.pageContext,
			pageTimer = v18.pageTimer
		})
	end

	if fFlagLuaAppEnableSduiHomePage and (v18.isOmni or props.isOmni) then
		local pageContext = v18.pageContext or props.pageContext
		local initialSortName = v18.initialSortName or props.initialSortName
		local initialSortIndex = v18.initialSortIndex or props.initialSortIndex
		return React.createElement(v6, {
			sortId = initialSortName,
			sortIndex = initialSortIndex,
			pageContext = pageContext
		})
	else
		local join = Cryo.Dictionary.join
		local v28 = {
			deviceType = v17,
			onActivateTooltip = v16,
			sponsoredTooltipBody = sponsoredDisclosure,
			sponsoredTooltipTitle = sponsoredTitle,
			useCreationCenterTitle = v19,
			useCategoryScrollList = v20,
			categorySelectorHeight = v21.Size.Size_1200,
			topBarCategoriesScrollerHeight = v21.Size.Size_2000,
			topBarCategoriesScrollerPadding = v21.Size.Size_400,
			hasTopBar = v23,
			backgroundTransparency = v22 and 1 or v21.LuaApps.SeeAll.BackgroundTransparency,
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

		if not module19 then
			v22 = nil
		end

		v28.hasThemeBackground = v22
		v28.safeAreaPadding = v21.Size.Size_1600

		v28.stableContentWidth = v25

		if not fFlagLuaAppLayoutParamsInContext then
			state2 = nil
		end

		v28.contentFrame = state2

		if not fFlagLuaAppLayoutParamsInContext then
			setState2 = nil
		end

		v28.setContentFrame = setState2
		v28.setScrollingFrame = setState
		v28.containerRef = ref
		v28.isScrollingEnabled = v26
		local v29 = join(props, v28, v18)

		return Roact.createElement(v12, v29)
	end
end)

return roactServices.connect({
	networking = roactNetworking,
	eventIngest = appEventIngestService,
	analytics = roactAnalyticsCommonGameEvents,
	appAnalytics = roactAnalytics,
	loggingProtocol = appLogging
})(v13)
