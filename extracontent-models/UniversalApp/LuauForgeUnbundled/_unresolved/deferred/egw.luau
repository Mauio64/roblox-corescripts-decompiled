local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/ego")
local React = require(CorePackages.Packages.React)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egx")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module4 = require("@luauforge/bundled/egs")
local module5 = require("@luauforge/bundled/cBc")
local module6 = require("@luauforge/bundled/egz")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local emptyState = UIBlox.App.Indicator.EmptyState
local loadingStatePage = UIBlox.App.Container.LoadingStatePage

local retrievalStatus2 = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local screenSizeImpressionsDetector = require("@luauforge/bundled/egA").ScreenSizeImpressionsDetector

local module7 = require("@luauforge/bundled/dzD")
local module8 = require("@luauforge/bundled/egB")
local module9 = require("@luauforge/bundled/egC")

local module10 = require("@luauforge/bundled/ehb")
local module11 = require("@luauforge/deferred/ehF")

local module12 = require("@luauforge/bundled/ehc")
local eventNames = module12.Analytics.EventNames
local analytics = module12.Analytics.Analytics
local fireImpressionEvent = module12.Analytics.fireImpressionEvent

local module13 = require("@luauforge/bundled/ecs")
local timers = module13.Analytics.Timing.Timers
local reportPromiseLoadingTimeWrapper = module13.Analytics.Timing.reportPromiseLoadingTimeWrapper
local paginationMethod = require("@luauforge/bundled/dtb").Modules.LuaApp.Enum.PaginationMethod
local searchTextBanner = require("@luauforge/bundled/dtb").Modules.Personalization.Search.SearchTextBanner
local useLastInputMode = require("@luauforge/bundled/ehL").useLastInputMode
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/AppBlox").useAnimateScrollViewToSelection

local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

local fFlagPlayerSearchEnableOnlineFrequentsForAll = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlayerSearchEnableOnlineFrequentsForAll

local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagExtendScrollingFramesBySafeInsets

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields

local fFlagSafetyResourceBannerTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSafetyResourceBannerTelemetry
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes

local extended = module2.PureComponent:extend("PlayerSearchPage")

local strictInterface = t.strictInterface
local v5 = {
	searchUuid = t.optional(t.string),
	omniSearchUuid = t.optional(t.string),
	backgroundTransparency = t.optional(t.number),
	searchParameters = t.table,
	onScrollDirectionChanged = t.optional(t.callback),
	shouldShowUserSearchLandingPage = t.optional(t.boolean),
	isRoutedFromAutoSearch = t.optional(t.boolean),
	enableNewEmptySearchUI = t.optional(t.boolean),
	canvasTopPadding = 0,
	hotlineSearchText = 0,
	hotlineSafetyResource = 0,
	defaultFocusRef = 0,
	screenSize = 0,
	usersSearchResult = 0,
	searchWordLengthNotSupported = 0,
	playerSearchStatus = 0,
	autoTabSearchStatus = 0,
	wideMode = 0,
	fetchPlayerSearch = 0,
	removeUserSearchResults = 0,
	removeTextSearchResults = 0,
	networking = 0,
	eventIngest = 0,
	enablePresenceIndicator = 0,
	enableOnlineFrequents = 0,
	appPage = 0
}
local v6 = if fFlagAppIaScrollAway then t.optional(t.number) else nil
v5.canvasTopPadding = v6
v5.hotlineSearchText = t.optional(t.string)

local v7 = if fFlagSafetyResourceBannerTelemetry then t.optional(t.strictInterface({
	moderationCategory = t.string,
	textFilterRequestId = t.string
})) else nil
v5.hotlineSafetyResource = v7

v5.defaultFocusRef = t.optional(t.callback)

v5.screenSize = t.Vector2
v5.usersSearchResult = t.optional(t.table)
v5.searchWordLengthNotSupported = t.boolean
v5.playerSearchStatus = t.string
v5.autoTabSearchStatus = t.optional(t.string)
v5.wideMode = t.optional(t.boolean)

v5.fetchPlayerSearch = t.callback
v5.removeUserSearchResults = t.callback
v5.removeTextSearchResults = t.callback

v5.networking = t.callback
v5.eventIngest = t.optional(t.table)

v5.enablePresenceIndicator = t.optional(t.boolean)
v5.enableOnlineFrequents = t.optional(t.boolean)
local v8 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then t.optional(t.string) else nil
v5.appPage = v8
extended.validateProps = strictInterface(v5)

function extended:init()
	local screenSize = self.props.screenSize
	local pageSideMargin = module6.getPageSideMargin(screenSize.X)
	self.userSearchUuid = self.props.searchUuid or HttpService:GenerateGUID(false)

	local v11 = {
		globalSessionId = self.props.omniSearchUuid,
		userSearchSessionId = self.userSearchUuid,
		pageContext = 0
	}
	local v12 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then self.props.appPage else nil
	v11.pageContext = v12
	self.Analytics = analytics({ infoForAllEvents = v11 })

	self.state = {
		loaded = false,
		impressionsToSend = nil,
		contentSize = Vector2.new(screenSize.X - 2 * pageSideMargin, screenSize.Y),
		itemsPerRow = 1
	}

	self.onRequestImpressionsSignal = signal.new()

	function self.onImpressionsDetected(list)
		if not list or #list == 0 then
			return
		end

		self:setState({ impressionsToSend = list })
	end

	function self.onItemsPerRowChanged(p2)
		self:setState({ itemsPerRow = p2 })
	end

	function self.sendPlayerTileImpressions(p2)
		fireImpressionEvent({
			impressions = p2,
			entries = self.props.usersSearchResult and self.props.usersSearchResult.entries or nil,
			itemsPerRow = self.state.itemsPerRow,
			startRowNumber = 1
		}, self.Analytics.fireAnalyticsEvent)
	end

	function self.onAbsoluteContentSizeChanged(p2)
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

	function self.fireSearchPageLoadEvents(p2, p3, p4)
		local nextPage = p3.nextPage or false
		local fireAnalyticsEvent = self.Analytics.fireAnalyticsEvent
		fireAnalyticsEvent(eventNames.UserSearchLoadingTime, {
			status = p3.status,
			loadingTime = p4,
			nextPage = nextPage
		})

		fireAnalyticsEvent(eventNames.UserSearchLoaded, {
			status = p3.status,
			nextPage = nextPage
		})
	end

	function self.fetchPlayerSearch(p2, p3)
		return reportPromiseLoadingTimeWrapper(self.props.fetchPlayerSearch, function(p4)
			return { fetch = "userSearch", nextPage = p3.nextPage }
		end, { fireEvent = self.fireSearchPageLoadEvents })(p2, p3):catch(function()
			return module4.resolve()
		end)
	end

	self.loadingTimers = timers()

	function self.reportLoadingTimeForPromise(callback, p2)
		local v13 = self.loadingTimers.start()

		local function fn(p3)
			local v14 = self.loadingTimers.stop(v13)
			local fireAnalyticsEvent = self.Analytics.fireAnalyticsEvent

			local userSearchLoadingTime = eventNames.UserSearchLoadingTime

			local v16 = if p2 then p2.nextPage else false
			fireAnalyticsEvent(userSearchLoadingTime, {
				status = p3,
				loadingTime = v14,
				nextPage = v16
			})
		end

		return callback():andThen(function()
			fn(retrievalStatus.Done.rawValue())
		end):catch(function()
			fn(retrievalStatus.Failed.rawValue())
		end)
	end

	function self.onLoadMore()
		local networking = self.props.networking
		local searchKeyword = self.props.searchParameters.searchKeyword

		return self.fetchPlayerSearch(networking, {
			keyword = searchKeyword,
			searchUuid = self.userSearchUuid,
			omniSearchUuid = self.props.omniSearchUuid,
			nextPage = true
		})
	end

	function self.dispatchInitialSearch()
		if self.props.isRoutedFromAutoSearch then
			if self.props.autoTabSearchStatus == retrievalStatus2.Done and self.state.loaded == false then
				self:setState({ loaded = true })
			end

			return module4.resolve()
		else
			local networking = self.props.networking
			local searchKeyword = self.props.searchParameters.searchKeyword

			if searchKeyword and utf8.len(searchKeyword) >= module7.PLAYER_SEARCH_MIN_KEYWORD_UTF8_LEN then
				return self.fetchPlayerSearch(networking, {
					keyword = searchKeyword,
					searchUuid = self.userSearchUuid,
					omniSearchUuid = self.props.omniSearchUuid,
					nextPage = false
				})
			end

			return nil
		end
	end
end

function extended:didMount()
	self.isMounted = true
	self.dispatchInitialSearch()
end

function extended:willUnmount()
	self.isMounted = false

	if self.props.searchParameters.searchKeyword then
		self.props.removeUserSearchResults(self.props.searchParameters.searchKeyword)
	end

	if self.userSearchUuid then
		self.props.removeTextSearchResults(self.userSearchUuid)
	end
end

local function PlayerSearchPageLoaded(props)
	local ref = React.useRef(nil)
	local v9 = useLastInputMode() == "Cursor" or ref.current == nil
	useAnimateScrollViewToSelection(ref, 0.4)

	local createElement = module2.createElement
	local v11 = {
		ref = props.defaultFocusRef,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement2 = module2.createElement
	local refsByRef = {
		[module2.Ref] = ref,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		CanvasSize = UDim2.new(1, 0, 1, 0),
		ScrollingEnabled = v9,
		refresh = props.refresh
	}
	local v13 = if props.hasMoreEntries and props.usersSearchResult.paginationMethod == paginationMethod.Button and props.playerSearchStatus ~= retrievalStatus2.Fetching then props.localized.loadMoreButtonText else nil
	refsByRef.loadMoreButtonText = v13

	refsByRef.BackgroundTransparency = props.backgroundTransparency
	local v14 = if fFlagAppIaScrollAway then props.canvasTopPadding else nil
	refsByRef.canvasTopPadding = v14
	refsByRef.onLoadMore = props.onLoadMore
	refsByRef.onScrollDirectionChanged = props.onScrollDirectionChanged
	refsByRef.onCanvasPositionChangedCallback = module8(function()
		props.onRequestImpressionsSignal:fire()
	end, 0.2)
	refsByRef.shouldExtendIntoSafeArea = fFlagExtendScrollingFramesBySafeInsets
		and { left = false, top = false, right = false, bottom = true }
		or nil

	local children2 = {
		Layout = module2.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			[module2.Change.AbsoluteContentSize] = props.onAbsoluteContentSizeChanged
		}),
		Padding = module2.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, props.sidePadding),
			PaddingRight = UDim.new(0, props.sidePadding),
			PaddingTop = UDim.new(0, module5.Constants.GAME_GRID_PADDING),
			PaddingBottom = UDim.new(0, module5.Constants.GAME_GRID_PADDING)
		}),
		PlayerGrid = 0
	}

	local createElement4 = module2.createElement
	local v16 = {
		LayoutOrder = 1,
		entries = props.entries,
		searchParameters = props.searchParameters,
		horizontalAlignment = Enum.HorizontalAlignment.Left,
		windowSize = Vector2.new(props.contentSize.X, props.screenSize.Y),
		impressionsTag = "PLAYER_TILE_IMPRESSIONS",
		Analytics = props.Analytics,
		enablePresenceIndicator = props.enablePresenceIndicator,
		onItemsPerRowChanged = props.onItemsPerRowChanged,
		itemsPerRow = props.itemsPerRow,
		startRowNumber = 1,
		enableOnlineFrequents = 0
	}

	local v17 = if fFlagPlayerSearchEnableOnlineFrequents and not fFlagPlayerSearchEnableOnlineFrequentsForAll then props.enableOnlineFrequents else nil
	v16.enableOnlineFrequents = v17
	children2.PlayerGrid = createElement4(module10, v16)
	return createElement("Frame", v11, {
		Content = createElement2(module9, refsByRef, children2),
		ScreenSizeImpressionsDetector = module2.createElement(screenSizeImpressionsDetector, {
			onRequestImpressionsSignal = props.onRequestImpressionsSignal,
			onImpressionsDetected = props.onImpressionsDetected,
			impressionsTag = "PLAYER_TILE_IMPRESSIONS"
		})
	})
end

function extended.renderOnLoaded(props)
	local screenSize = props.props.screenSize
	local contentSize = props.state.contentSize
	local pageSideMargin = module6.getPageSideMargin(screenSize.X)
	local searchWordLengthNotSupported = props.props.searchWordLengthNotSupported

	local usersSearchResult = props.props.usersSearchResult
	local v9, v10

	if usersSearchResult then
		v9 = usersSearchResult.nextPageCursor
			and usersSearchResult.nextPageCursor ~= "EndOfPlayerSearch"
			and true
			or false

		v10 = usersSearchResult.entries
	else
		v10 = {}
		v9 = false
	end

	if props.props.hotlineSearchText then
		return module2.createElement(searchTextBanner, {
			text = props.props.hotlineSearchText,
			sidePadding = pageSideMargin,
			safetyResourceTelemetry = fFlagSafetyResourceBannerTelemetry and props.props.hotlineSafetyResource and {
				moderationCategory = props.props.hotlineSafetyResource.moderationCategory,
				textFilterRequestId = props.props.hotlineSafetyResource.textFilterRequestId,
				surface = searchTypes.Players
			} or nil
		})
	end

	if #v10 == 0 or searchWordLengthNotSupported then
		return module2.createElement(module11, {
			wideMode = props.props.wideMode,
			screenSize = props.props.screenSize,
			backgroundTransparency = props.props.backgroundTransparency,
			searchWordLengthNotSupported = searchWordLengthNotSupported,
			shouldShowUserSearchLandingPage = props.props.shouldShowUserSearchLandingPage,
			fireAnalyticsEvent = props.Analytics.fireAnalyticsEvent
		})
	end

	local v11 = {
		noResultsText = "Feature.PlayerSearchResults.Label.NoResultsFound",
		keywordTooShortText = "Feature.PlayerSearchResults.Label.KeywordTooShort",
		loadMoreButtonText = "Search.GlobalSearch.Action.LoadMore"
	}
	local onLoadMore

	if v9 and props.props.playerSearchStatus ~= retrievalStatus2.Fetching then
		onLoadMore = props.onLoadMore or nil
	else
		onLoadMore = nil
	end

	return withStyle(function(p2)
		return withLocalization(v11)(function(p3)
			local createElement = module2.createElement
			local v13 = {
				refresh = props.refresh,
				hasMoreEntries = v9,
				usersSearchResult = usersSearchResult,
				playerSearchStatus = props.props.playerSearchStatus,
				localized = p3,
				backgroundTransparency = props.props.backgroundTransparency,
				canvasTopPadding = 0,
				onLoadMore = 0,
				onScrollDirectionChanged = 0,
				onRequestImpressionsSignal = 0,
				sidePadding = 0,
				entries = 0,
				searchParameters = 0,
				contentSize = 0,
				screenSize = 0,
				onAbsoluteContentSizeChanged = 0,
				Analytics = 0,
				enablePresenceIndicator = 0,
				onItemsPerRowChanged = 0,
				itemsPerRow = 0,
				enableOnlineFrequents = 0,
				onImpressionsDetected = 0,
				defaultFocusRef = 0
			}
			local v14 = if fFlagAppIaScrollAway then props.props.canvasTopPadding else nil
			v13.canvasTopPadding = v14
			v13.onLoadMore = onLoadMore
			v13.onScrollDirectionChanged = props.props.onScrollDirectionChanged
			v13.onRequestImpressionsSignal = props.onRequestImpressionsSignal
			v13.sidePadding = pageSideMargin
			v13.entries = v10
			v13.searchParameters = props.props.searchParameters
			v13.contentSize = contentSize
			v13.screenSize = screenSize
			v13.onAbsoluteContentSizeChanged = props.onAbsoluteContentSizeChanged
			v13.Analytics = props.Analytics
			v13.enablePresenceIndicator = props.props.enablePresenceIndicator
			v13.onItemsPerRowChanged = props.onItemsPerRowChanged
			v13.itemsPerRow = props.state.itemsPerRow

			local v15 = if fFlagPlayerSearchEnableOnlineFrequents and not fFlagPlayerSearchEnableOnlineFrequentsForAll then props.props.enableOnlineFrequents else nil
			v13.enableOnlineFrequents = v15

			v13.onImpressionsDetected = props.onImpressionsDetected
			v13.defaultFocusRef = props.props.defaultFocusRef
			return createElement(PlayerSearchPageLoaded, v13)
		end)
	end)
end

function extended.renderOnFailed(p2, p3)
	return module2.createElement(emptyState, {
		onActivated = p2.dispatchInitialSearch,
		text = p3.failedMessage
	})
end

function extended:renderOnLoading()
	return withStyle(function(p3)
		return module2.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = p3.Theme.BackgroundDefault.Transparency,
				BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0
			},
			module2.createElement(loadingStatePage)
		)
	end)
end

function extended:render()
	local v9

	if self.props.isRoutedFromAutoSearch then
		v9 = self.props.autoTabSearchStatus
	else
		v9 = self.props.playerSearchStatus
	end

	return withLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet"
	})(function(p2)
		return module2.createElement(loadingStateContainer, {
			dataStatus = retrievalStatus.fromRawValue(v9),
			renderOnLoading = function()
				if self.state.loaded then
					return (self:renderOnLoaded())
				end

				return (self:renderOnLoading())
			end,
			renderOnFailed = function()
				return self:renderOnFailed(p2)
			end,
			renderOnLoaded = function()
				return self:renderOnLoaded()
			end
		})
	end)
end

function extended.didUpdate(object, p2, p3)
	module.assert(
		p2.searchUuid == object.props.searchUuid,
		`SearchUuid should not change during the lifetime of PlayerSearchPage, analytics could be incorrect; detected a change {p2.searchUuid} -> {object.props.searchUuid}`
	)
	local v9

	if object.props.isRoutedFromAutoSearch then
		v9 = object.props.autoTabSearchStatus
	else
		v9 = object.props.playerSearchStatus
	end

	if v9 ~= p2.playerSearchStatus then
		if v9 == retrievalStatus2.Done then
			if object.state.loaded == false then
				object:setState({ loaded = true })
			end

			object.onRequestImpressionsSignal:fire()
		elseif
			(v9 == retrievalStatus2.NotStarted or v9 == retrievalStatus2.Failed)
			and object.state.loaded == true
		then
			object:setState({ loaded = false })
		end
	end

	local impressionsToSend = object.state.impressionsToSend

	if impressionsToSend ~= nil and impressionsToSend ~= p3.impressionsToSend then
		object.sendPlayerTileImpressions(impressionsToSend)
		object:setState({ impressionsToSend = nil })
	end
end

return roactServices.connect({ networking = module3 })(extended)
