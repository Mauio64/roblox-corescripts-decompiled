local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Roact = require(Modules.Common.Roact)
local React = require(CorePackages.Packages.React)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Promise = require(Modules.LuaApp.Promise)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local EmptyState = UIBlox.App.Indicator.EmptyState
local LoadingStatePage = UIBlox.App.Container.LoadingStatePage
local RetrievalStatus2 = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local ScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsDetector
local Constants = require(Modules.LuaApp.Constants)
local debounce = require(Modules.LuaApp.Util.debounce)
local RefreshScrollingFrameWithLoadMore = require(Modules.LuaApp.Components.RefreshScrollingFrameWithLoadMore)
local PlayerGridWithUserSearchHydrationLayerWrapper = require(script.Parent.PlayerGridWithUserSearchHydrationLayerWrapper)
local EmptyPlayerSearchPage = require(script.Parent.EmptyPlayerSearchPage)
local api = require(Modules.LuaApp.Components.UserSearch.api)
local EventNames = api.Analytics.EventNames
local Analytics = api.Analytics.Analytics
local fireImpressionEvent = api.Analytics.fireImpressionEvent
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local Timers = SocialLuaAnalytics.Analytics.Timing.Timers
local reportPromiseLoadingTimeWrapper = SocialLuaAnalytics.Analytics.Timing.reportPromiseLoadingTimeWrapper
local PaginationMethod = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Enum.PaginationMethod
local SearchTextBanner = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.Search.SearchTextBanner
local useLastInputMode = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useLastInputMode
local useAnimateScrollViewToSelection = require(CorePackages.Workspace.Packages.AppBlox).useAnimateScrollViewToSelection
local FFlagAppIaScrollAway = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppIaScrollAway
local FFlagPlayerSearchEnableOnlineFrequents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents
local FFlagPlayerSearchEnableOnlineFrequentsForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerSearchEnableOnlineFrequentsForAll
local FFlagExtendScrollingFramesBySafeInsets = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local v46 = Roact.PureComponent:extend("PlayerSearchPage")

v46.validateProps = t.strictInterface({
	searchUuid = t.optional(t.string),
	omniSearchUuid = t.optional(t.string),
	backgroundTransparency = t.optional(t.number),
	searchParameters = t.table,
	onScrollDirectionChanged = t.optional(t.callback),
	shouldShowUserSearchLandingPage = t.optional(t.boolean),
	isRoutedFromAutoSearch = t.optional(t.boolean),
	enableNewEmptySearchUI = t.optional(t.boolean),
	canvasTopPadding = if not FFlagAppIaScrollAway then nil else t.optional(t.number),
	hotlineSearchText = t.optional(t.string),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	screenSize = t.Vector2,
	usersSearchResult = t.optional(t.table),
	searchWordLengthNotSupported = t.boolean,
	playerSearchStatus = t.string,
	autoTabSearchStatus = t.optional(t.string),
	wideMode = t.optional(t.boolean),
	fetchPlayerSearch = t.callback,
	removeUserSearchResults = t.callback,
	removeTextSearchResults = t.callback,
	networking = t.callback,
	eventIngest = t.optional(t.table),
	enablePresenceIndicator = t.optional(t.boolean),
	enableOnlineFrequents = t.optional(t.boolean),
	appPage = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t.optional(t.string)
})

function v46.init(p1) -- line: 110
	-- upvalues: DiscoveryUtils (copy), HttpService (copy), Analytics (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), Signal (copy), fireImpressionEvent (copy), EventNames (copy), reportPromiseLoadingTimeWrapper (copy), Promise (copy), Timers (copy), RetrievalStatus (copy), RetrievalStatus2 (copy), Constants (copy)
	local screenSize = p1.props.screenSize
	local v51 = DiscoveryUtils.getPageSideMargin(screenSize.X)

	p1.userSearchUuid = p1.props.searchUuid or HttpService:GenerateGUID(false)
	p1.Analytics = Analytics({
		infoForAllEvents = {
			globalSessionId = p1.props.omniSearchUuid,
			userSearchSessionId = p1.userSearchUuid,
			pageContext = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else p1.props.appPage
		}
	})
	p1.state = {
		loaded = false,
		impressionsToSend = nil,
		itemsPerRow = 1,
		contentSize = Vector2.new(screenSize.X - 2 * v51, screenSize.Y)
	}
	p1.onRequestImpressionsSignal = Signal.new()

	function p1.onImpressionsDetected(p2) -- line: 132
		-- upvalues: p1 (copy)
		if not p2 or #p2 == 0 then
			return
		end

		p1:setState({
			impressionsToSend = p2
		})
	end
	function p1.onItemsPerRowChanged(p3) -- line: 142
		-- upvalues: p1 (copy)
		p1:setState({
			itemsPerRow = p3
		})
	end
	function p1.sendPlayerTileImpressions(p4) -- line: 148
		-- upvalues: fireImpressionEvent (copy), p1 (copy)
		fireImpressionEvent({
			startRowNumber = 1,
			impressions = p4,
			entries = p1.props.usersSearchResult and p1.props.usersSearchResult.entries or nil,
			itemsPerRow = p1.state.itemsPerRow
		}, p1.Analytics.fireAnalyticsEvent)
	end
	function p1.onAbsoluteContentSizeChanged(p5) -- line: 157
		-- upvalues: p1 (copy)
		if p1.isMounted and p5 then
			local AbsoluteContentSize = p5.AbsoluteContentSize

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
	function p1.fireSearchPageLoadEvents(_, p7, p8) -- line: 172
		-- upvalues: p1 (copy), EventNames (copy)
		local v85 = p7.nextPage or false
		local fireAnalyticsEvent = p1.Analytics.fireAnalyticsEvent

		fireAnalyticsEvent(EventNames.UserSearchLoadingTime, {
			status = p7.status,
			loadingTime = p8,
			nextPage = v85
		})
		fireAnalyticsEvent(EventNames.UserSearchLoaded, {
			status = p7.status,
			nextPage = v85
		})
	end
	function p1.fetchPlayerSearch(p9, p10) -- line: 186
		-- upvalues: reportPromiseLoadingTimeWrapper (copy), p1 (copy), Promise (copy)
		return reportPromiseLoadingTimeWrapper(p1.props.fetchPlayerSearch, function(_) -- line: 189
			-- upvalues: p10 (copy)
			return {
				fetch = "userSearch",
				nextPage = p10.nextPage
			}
		end, {
			fireEvent = p1.fireSearchPageLoadEvents
		})(p9, p10):catch(function() -- line: 195
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end

	p1.loadingTimers = Timers()

	function p1.reportLoadingTimeForPromise(p12, p13) -- line: 202
		-- upvalues: p1 (copy), EventNames (copy), RetrievalStatus (copy)
		local v91 = p1.loadingTimers.start()

		local function v92(p14) -- line: 205
			-- upvalues: p1 (copy), v91 (copy), EventNames (copy), p13 (copy)
			local v102 = p1.loadingTimers.stop(v91)

			p1.Analytics.fireAnalyticsEvent(EventNames.UserSearchLoadingTime, {
				status = p14,
				loadingTime = v102,
				nextPage = not not p13 and p13.nextPage
			})
		end

		return p12():andThen(function() -- line: 217
			-- upvalues: v92 (copy), RetrievalStatus (copy)
			v92(RetrievalStatus.Done.rawValue())
		end):catch(function() -- line: 220
			-- upvalues: v92 (copy), RetrievalStatus (copy)
			v92(RetrievalStatus.Failed.rawValue())
		end)
	end
	function p1.onLoadMore() -- line: 225
		-- upvalues: p1 (copy)
		local networking = p1.props.networking
		local searchKeyword = p1.props.searchParameters.searchKeyword

		return p1.fetchPlayerSearch(networking, {
			nextPage = true,
			keyword = searchKeyword,
			searchUuid = p1.userSearchUuid,
			omniSearchUuid = p1.props.omniSearchUuid
		})
	end
	function p1.dispatchInitialSearch() -- line: 238
		-- upvalues: p1 (copy), RetrievalStatus2 (copy), Promise (copy), Constants (copy)
		if p1.props.isRoutedFromAutoSearch then
			if p1.props.autoTabSearchStatus == RetrievalStatus2.Done and p1.state.loaded == false then
				p1:setState({
					loaded = true
				})
			end

			return Promise.resolve()
		end

		local networking = p1.props.networking
		local searchKeyword = p1.props.searchParameters.searchKeyword

		if searchKeyword and utf8.len(searchKeyword) >= Constants.PLAYER_SEARCH_MIN_KEYWORD_UTF8_LEN then
			return p1.fetchPlayerSearch(networking, {
				nextPage = false,
				keyword = searchKeyword,
				searchUuid = p1.userSearchUuid,
				omniSearchUuid = p1.props.omniSearchUuid
			})
		end

		return nil
	end
end
function v46.didMount(p15) -- line: 268
	p15.isMounted = true
	p15.dispatchInitialSearch()
end
function v46.willUnmount(p16) -- line: 273
	p16.isMounted = false

	if p16.props.searchParameters.searchKeyword then
		p16.props.removeUserSearchResults(p16.props.searchParameters.searchKeyword)
	end

	if p16.userSearchUuid then
		p16.props.removeTextSearchResults(p16.userSearchUuid)
	end
end

local function PlayerSearchPageLoaded(t1: {[any]: any}) -- line: 311
	-- upvalues: React (copy), useLastInputMode (copy), useAnimateScrollViewToSelection (copy), Roact (copy), FFlagLuaAppsDefaultSelection (copy), RefreshScrollingFrameWithLoadMore (copy), PaginationMethod (copy), RetrievalStatus2 (copy), FFlagAppIaScrollAway (copy), debounce (copy), FFlagExtendScrollingFramesBySafeInsets (copy), DiscoveryTypes (copy), PlayerGridWithUserSearchHydrationLayerWrapper (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy), ScreenSizeImpressionsDetector (copy)
	local v55 = React.useRef(nil)
	local v56 = useLastInputMode() == "Cursor" or v55.current == nil

	useAnimateScrollViewToSelection(v55, 0.4)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = if not FFlagLuaAppsDefaultSelection then nil else t1.defaultFocusRef,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Content = Roact.createElement(RefreshScrollingFrameWithLoadMore, {
			[Roact.Ref] = v55,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			CanvasSize = UDim2.new(1, 0, 1, 0),
			ScrollingEnabled = v56,
			refresh = t1.refresh,
			loadMoreButtonText = if not t1.hasMoreEntries or (t1.usersSearchResult.paginationMethod ~= PaginationMethod.Button or t1.playerSearchStatus == RetrievalStatus2.Fetching) then nil else t1.localized.loadMoreButtonText,
			BackgroundTransparency = t1.backgroundTransparency,
			canvasTopPadding = if not FFlagAppIaScrollAway then nil else t1.canvasTopPadding,
			onLoadMore = t1.onLoadMore,
			onScrollDirectionChanged = t1.onScrollDirectionChanged,
			onCanvasPositionChangedCallback = debounce(function() -- line: 338
				-- upvalues: t1 (copy)
				t1.onRequestImpressionsSignal:fire()
			end, 0.2),
			shouldExtendIntoSafeArea = if not FFlagExtendScrollingFramesBySafeInsets then nil else {
				left = false,
				top = false,
				right = false,
				bottom = true
			}
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
				[Roact.Change.AbsoluteContentSize] = t1.onAbsoluteContentSizeChanged
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, t1.sidePadding),
				PaddingRight = UDim.new(0, t1.sidePadding),
				PaddingTop = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING),
				PaddingBottom = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING)
			}),
			PlayerGrid = Roact.createElement(PlayerGridWithUserSearchHydrationLayerWrapper, {
				LayoutOrder = 1,
				impressionsTag = "PLAYER_TILE_IMPRESSIONS",
				startRowNumber = 1,
				entries = t1.entries,
				searchParameters = t1.searchParameters,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				windowSize = Vector2.new(t1.contentSize.X, t1.screenSize.Y),
				Analytics = t1.Analytics,
				enablePresenceIndicator = t1.enablePresenceIndicator,
				onItemsPerRowChanged = t1.onItemsPerRowChanged,
				itemsPerRow = t1.itemsPerRow,
				enableOnlineFrequents = if not FFlagPlayerSearchEnableOnlineFrequents or FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else t1.enableOnlineFrequents
			})
		}),
		ScreenSizeImpressionsDetector = Roact.createElement(ScreenSizeImpressionsDetector, {
			impressionsTag = "PLAYER_TILE_IMPRESSIONS",
			onRequestImpressionsSignal = t1.onRequestImpressionsSignal,
			onImpressionsDetected = t1.onImpressionsDetected
		})
	})
end

function v46.renderOnLoaded(p17) -- line: 389
	-- upvalues: DiscoveryUtils (copy), Roact (copy), SearchTextBanner (copy), EmptyPlayerSearchPage (copy), RetrievalStatus2 (copy), withStyle (copy), withLocalization (copy), FFlagEnableLeftNavOnConsole (copy), PlayerSearchPageLoaded (copy), FFlagAppIaScrollAway (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy), FFlagLuaAppsDefaultSelection (copy), RefreshScrollingFrameWithLoadMore (copy), PaginationMethod (copy), debounce (copy), FFlagExtendScrollingFramesBySafeInsets (copy), DiscoveryTypes (copy), PlayerGridWithUserSearchHydrationLayerWrapper (copy), ScreenSizeImpressionsDetector (copy)
	local screenSize = p17.props.screenSize
	local contentSize = p17.state.contentSize
	local v60 = DiscoveryUtils.getPageSideMargin(screenSize.X)
	local searchWordLengthNotSupported = p17.props.searchWordLengthNotSupported
	local u62 = false
	local t2 = {}
	local usersSearchResult = p17.props.usersSearchResult

	if usersSearchResult then
		u62 = not not usersSearchResult.nextPageCursor and usersSearchResult.nextPageCursor ~= "EndOfPlayerSearch"
		t2 = usersSearchResult.entries
	end

	if p17.props.hotlineSearchText then
		return Roact.createElement(SearchTextBanner, {
			text = p17.props.hotlineSearchText,
			sidePadding = v60
		})
	end

	if #t2 == 0 or searchWordLengthNotSupported then
		return Roact.createElement(EmptyPlayerSearchPage, {
			wideMode = p17.props.wideMode,
			screenSize = p17.props.screenSize,
			backgroundTransparency = p17.props.backgroundTransparency,
			searchWordLengthNotSupported = searchWordLengthNotSupported,
			shouldShowUserSearchLandingPage = p17.props.shouldShowUserSearchLandingPage,
			fireAnalyticsEvent = p17.Analytics.fireAnalyticsEvent
		})
	end

	local t3 = {
		noResultsText = "Feature.PlayerSearchResults.Label.NoResultsFound",
		keywordTooShortText = "Feature.PlayerSearchResults.Label.KeywordTooShort",
		loadMoreButtonText = "Search.GlobalSearch.Action.LoadMore"
	}
	local v66 = u62 and (p17.props.playerSearchStatus ~= RetrievalStatus2.Fetching and p17.onLoadMore) or nil

	return withStyle(function(_) -- line: 435
		-- upvalues: withLocalization (copy), t3 (copy), FFlagEnableLeftNavOnConsole (copy), Roact (copy), PlayerSearchPageLoaded (copy), p17 (copy), u62 (ref), usersSearchResult (copy), FFlagAppIaScrollAway (copy), v66 (copy), v60 (copy), t2 (ref), contentSize (copy), screenSize (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy), FFlagLuaAppsDefaultSelection (copy), RefreshScrollingFrameWithLoadMore (copy), PaginationMethod (copy), RetrievalStatus2 (copy), debounce (copy), FFlagExtendScrollingFramesBySafeInsets (copy), DiscoveryTypes (copy), PlayerGridWithUserSearchHydrationLayerWrapper (copy), ScreenSizeImpressionsDetector (copy)
		return withLocalization(t3)(function(p19) -- line: 436
			-- upvalues: FFlagEnableLeftNavOnConsole (copy), Roact (copy), PlayerSearchPageLoaded (copy), p17 (copy), u62 (ref), usersSearchResult (copy), FFlagAppIaScrollAway (copy), v66 (copy), v60 (copy), t2 (ref), contentSize (copy), screenSize (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy), FFlagLuaAppsDefaultSelection (copy), RefreshScrollingFrameWithLoadMore (copy), PaginationMethod (copy), RetrievalStatus2 (copy), debounce (copy), FFlagExtendScrollingFramesBySafeInsets (copy), DiscoveryTypes (copy), PlayerGridWithUserSearchHydrationLayerWrapper (copy), ScreenSizeImpressionsDetector (copy)
			if FFlagEnableLeftNavOnConsole then
				return Roact.createElement(PlayerSearchPageLoaded, {
					refresh = p17.refresh,
					hasMoreEntries = u62,
					usersSearchResult = usersSearchResult,
					playerSearchStatus = p17.props.playerSearchStatus,
					localized = p19,
					backgroundTransparency = p17.props.backgroundTransparency,
					canvasTopPadding = if not FFlagAppIaScrollAway then nil else p17.props.canvasTopPadding,
					onLoadMore = v66,
					onScrollDirectionChanged = p17.props.onScrollDirectionChanged,
					onRequestImpressionsSignal = p17.onRequestImpressionsSignal,
					sidePadding = v60,
					entries = t2,
					searchParameters = p17.props.searchParameters,
					contentSize = contentSize,
					screenSize = screenSize,
					onAbsoluteContentSizeChanged = p17.onAbsoluteContentSizeChanged,
					Analytics = p17.Analytics,
					enablePresenceIndicator = p17.props.enablePresenceIndicator,
					onItemsPerRowChanged = p17.onItemsPerRowChanged,
					itemsPerRow = p17.state.itemsPerRow,
					enableOnlineFrequents = if not FFlagPlayerSearchEnableOnlineFrequents or FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else p17.props.enableOnlineFrequents,
					onImpressionsDetected = p17.onImpressionsDetected,
					defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p17.props.defaultFocusRef
				})
			end

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Content = Roact.createElement(RefreshScrollingFrameWithLoadMore, {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					CanvasSize = UDim2.new(1, 0, 1, 0),
					refresh = p17.refresh,
					loadMoreButtonText = if not u62 or (usersSearchResult.paginationMethod ~= PaginationMethod.Button or p17.props.playerSearchStatus == RetrievalStatus2.Fetching) then nil else p19.loadMoreButtonText,
					BackgroundTransparency = p17.props.backgroundTransparency,
					canvasTopPadding = if not FFlagAppIaScrollAway then nil else p17.props.canvasTopPadding,
					onLoadMore = v66,
					onScrollDirectionChanged = p17.props.onScrollDirectionChanged,
					onCanvasPositionChangedCallback = debounce(function() -- line: 486
						-- upvalues: p17 (copy)
						p17.onRequestImpressionsSignal:fire()
					end, 0.2),
					shouldExtendIntoSafeArea = if not FFlagExtendScrollingFramesBySafeInsets then nil else {
						left = false,
						top = false,
						right = false,
						bottom = true
					}
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12),
						[Roact.Change.AbsoluteContentSize] = p17.onAbsoluteContentSizeChanged
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v60),
						PaddingRight = UDim.new(0, v60),
						PaddingTop = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING),
						PaddingBottom = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING)
					}),
					PlayerGrid = Roact.createElement(PlayerGridWithUserSearchHydrationLayerWrapper, {
						LayoutOrder = 1,
						impressionsTag = "PLAYER_TILE_IMPRESSIONS",
						startRowNumber = 1,
						entries = t2,
						searchParameters = p17.props.searchParameters,
						horizontalAlignment = Enum.HorizontalAlignment.Left,
						windowSize = Vector2.new(contentSize.X, screenSize.Y),
						Analytics = p17.Analytics,
						enablePresenceIndicator = p17.props.enablePresenceIndicator,
						onItemsPerRowChanged = p17.onItemsPerRowChanged,
						itemsPerRow = p17.state.itemsPerRow,
						enableOnlineFrequents = if not FFlagPlayerSearchEnableOnlineFrequents or FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else p17.props.enableOnlineFrequents
					})
				}),
				ScreenSizeImpressionsDetector = Roact.createElement(ScreenSizeImpressionsDetector, {
					impressionsTag = "PLAYER_TILE_IMPRESSIONS",
					onRequestImpressionsSignal = p17.onRequestImpressionsSignal,
					onImpressionsDetected = p17.onImpressionsDetected
				})
			})
		end)
	end)
end
function v46.renderOnFailed(p20, p21) -- line: 540
	-- upvalues: Roact (copy), EmptyState (copy)
	return Roact.createElement(EmptyState, {
		onActivated = p20.dispatchInitialSearch,
		text = p21.failedMessage
	})
end
function v46.renderOnLoading(_) -- line: 547
	-- upvalues: withStyle (copy), Roact (copy), LoadingStatePage (copy)
	return withStyle(function(p23) -- line: 548
		-- upvalues: Roact (copy), LoadingStatePage (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = p23.Theme.BackgroundDefault.Transparency,
			BackgroundColor3 = p23.Theme.BackgroundDefault.Color
		}, Roact.createElement(LoadingStatePage))
	end)
end
function v46.render(p24) -- line: 558
	-- upvalues: withLocalization (copy), Roact (copy), LoadingStateContainer (copy), RetrievalStatus (copy)
	local v71 = if not p24.props.isRoutedFromAutoSearch then p24.props.playerSearchStatus else p24.props.autoTabSearchStatus

	return withLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet"
	})(function(p25) -- line: 565
		-- upvalues: Roact (copy), LoadingStateContainer (copy), RetrievalStatus (copy), v71 (copy), p24 (copy)
		return Roact.createElement(LoadingStateContainer, {
			dataStatus = RetrievalStatus.fromRawValue(v71),
			renderOnLoading = function() -- line: 568
				-- upvalues: p24 (copy)
				if p24.state.loaded then
					return (p24:renderOnLoaded())
				end

				return (p24:renderOnLoading())
			end,
			renderOnFailed = function() -- line: 571
				-- upvalues: p24 (copy), p25 (copy)
				return p24:renderOnFailed(p25)
			end,
			renderOnLoaded = function() -- line: 574
				-- upvalues: p24 (copy)
				return p24:renderOnLoaded()
			end
		})
	end)
end
function v46.didUpdate(p26, p27, p28) -- line: 581
	-- upvalues: ArgCheck (copy), RetrievalStatus2 (copy)
	ArgCheck.assert(p27.searchUuid == p26.props.searchUuid, `SearchUuid should not change during the lifetime of PlayerSearchPage, analytics could be incorrect; detected a change { p27.searchUuid } -> { p26.props.searchUuid }`)

	local v75 = if not p26.props.isRoutedFromAutoSearch then p26.props.playerSearchStatus else p26.props.autoTabSearchStatus

	if v75 ~= p27.playerSearchStatus then
		if v75 == RetrievalStatus2.Done then
			if p26.state.loaded == false then
				p26:setState({
					loaded = true
				})
			end

			p26.onRequestImpressionsSignal:fire()
		elseif (v75 == RetrievalStatus2.NotStarted or v75 == RetrievalStatus2.Failed) and p26.state.loaded == true then
			p26:setState({
				loaded = false
			})
		end
	end

	local impressionsToSend = p26.state.impressionsToSend

	if impressionsToSend ~= nil and impressionsToSend ~= p28.impressionsToSend then
		p26.sendPlayerTileImpressions(impressionsToSend)
		p26:setState({
			impressionsToSend = nil
		})
	end
end

return RoactServices.connect({
	networking = RoactNetworking
})(v46)
