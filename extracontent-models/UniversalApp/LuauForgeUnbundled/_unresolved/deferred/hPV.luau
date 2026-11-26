local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local feedScroll = require("@luauforge/bundled/hPW").feedScroll
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local context = require("@luauforge/bundled/dzG").Constants.Context
local module = require("@luauforge/bundled/dDZ")
local useCollectionLayoutConfig = require("@luauforge/bundled/ehg").useCollectionLayoutConfig
local omniFeedTypes = require("@luauforge/bundled/cBc").OmniFeedTypes
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local module3 = require("@luauforge/bundled/gDL")
local useFeedVideoPlaybackContext = module3.useFeedVideoPlaybackContext
local videoEndReason = module3.AnalyticsEnums.VideoEndReason

local modules = require("@luauforge/bundled/dtb").Modules
local fetchDataWithErrorToasts = modules.LuaApp.Thunks.FetchDataWithErrorToasts
local searchRetrievalStatus = modules.LuaApp.Enum.SearchRetrievalStatus
local apiFetchGameSearchResults = modules.LuaApp.Thunks.Search.ApiFetchGameSearchResults
local paginationMethod = modules.LuaApp.Enum.PaginationMethod
local context2 = modules.LuaApp.Components.Search.SearchTypeSelection.Context

local module4 = require("@luauforge/bundled/hPX")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppSearchResultsPageGameTileVideo = SharedFlags.FFlagLuaAppSearchResultsPageGameTileVideo
local fFlagLuaAppVideoAutoplayFeedElection = SharedFlags.FFlagLuaAppVideoAutoplayFeedElection
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

return function(props)
	local searchPage = appPage.SearchPage
	local ref = if not fFlagLuaAppLayoutParamsInContext then React.useRef(nil) else nil
	local state, setState

	if fFlagLuaAppLayoutParamsInContext then
		state, setState = React.useState(nil)
	else
		state = nil
	end

	local v5 = useLocalization({
		loadMoreButtonText = "Search.GlobalSearch.Action.LoadMore"
	})

	local searchUuid = props.searchUuid

	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(appEventIngestService)
	local v8 = useSelector(function(p2)
		return p2.Search.SearchesInGames[searchUuid]
	end)

	local v9 = useSelector(function(p2)
		if searchUuid and p2.SearchesParameters[searchUuid] then
			return p2.SearchesParameters[searchUuid].searchKeyword
		end

		return nil
	end)

	local v10 = useSelector(function(p2)
		return p2.RequestsStatus.SearchesInGamesStatus[searchUuid]
	end)

	local v11 = useSelector(function(p2)
		return p2.Personalization.OrderedOmniItems[searchPage]
			and p2.Personalization.OrderedOmniItems[searchPage][searchUuid]
			or nil
	end)

	local allItems = v11 and v11.allItems or {}
	local v12 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v13 = useDispatch()
	local function fn()
		return v13(fetchDataWithErrorToasts(apiFetchGameSearchResults(v6, {
			searchKeyword = v9,
			searchUuid = props.searchUuid,
			omniSearchUuid = props.omniSearchUuid,
			isAppend = true
		})))
	end

	local v14 = React.useCallback(function()
		return v13(fetchDataWithErrorToasts(apiFetchGameSearchResults(v6, {
			searchKeyword = v9,
			searchUuid = searchUuid,
			omniSearchUuid = props.omniSearchUuid,
			isAppend = false
		})))
	end, { v13, v6, v9, searchUuid, props.omniSearchUuid })

	local function fn2(p2, scrollDuration, startPos)
		local v15 = if fFlagLuaAppLayoutParamsInContext then state else ref.current

		local scrollingDirection = if v15 then v15.ScrollingDirection else nil

		if scrollingDirection then
			local v16 = 0

			if v15 then
				if scrollingDirection == Enum.ScrollingDirection.X then
					v16 = v15.AbsoluteSize.X
				elseif scrollingDirection == Enum.ScrollingDirection.Y then
					v16 = v15.AbsoluteSize.Y
				else
					mutedError(`Direction {scrollingDirection.Name} is an unsupported option for feedScroll event`)
				end
			end

			local v17 = {
				distance = p2,
				screenSizeX = v12.X,
				screenSizeY = v12.Y,
				scrollAreaSize = v16,
				scrollDepth = 0,
				startDepth = 0,
				startPos = 0,
				scrollDuration = 0
			}

			local v18 = if v16 > 0 then p2 / v16 else nil
			v17.scrollDepth = v18
			local v19 = if v16 > 0 then startPos / v16 else nil
			v17.startDepth = v19
			v17.startPos = startPos
			v17.scrollDuration = scrollDuration

			feedScroll(v7, searchPage, scrollingDirection, v17)
		end
	end

	local v15 = props.paginationMethod == paginationMethod.Button and v8.hasMoreRows

	local v16 = if fFlagLuaAppLayoutParamsInContext then useCollectionLayoutConfig(state) else nil

	local useSduiContextFromRoduxAndProcessConfigs = module.useSduiContextFromRoduxAndProcessConfigs

	if not fFlagLuaAppLayoutParamsInContext then
		v16 = nil
	end

	local v17 = useSduiContextFromRoduxAndProcessConfigs(searchPage, v16, `{searchPage}_{searchUuid}`)
	local v18, v19, v20

	if fFlagLuaAppSearchResultsPageGameTileVideo then
		local v21 = usePreferredInput()

		local v22 = React.useContext(context2)
		local v24 = (if v22 then v22.activeSearchType else nil) == searchTypes.Games

		local v26 = if not fFlagLuaAppOneByTwoHoverIdleAutoplay then v21 == Responsive.Input.Touch else nil
		local v30

		if fFlagLuaAppOneByTwoHoverIdleAutoplay then
			v30 = module3.getPlaybackDetectionMethod(v21, false)
		end

		v18, v19, v20 = useFeedVideoPlaybackContext(
			v26,
			not v24 or nil,
			fFlagLuaAppVideoAutoplayFeedElection and true or nil,
			fFlagLuaAppVideoAutoplayFeedElection and true or nil,
			v30
		)

		if fFlagLuaAppVideoAutoplayFeedElection then
			local v31 = #allItems > 0

			local viewportVideoAutoplayController = if v18 then v18.viewportVideoAutoplayController else nil

			React.useEffect(function()
				if not viewportVideoAutoplayController then
					return
				end

				if not v24 then
					viewportVideoAutoplayController:reset(videoEndReason.ExitViewport)
					return
				end

				if not v31 then
					return
				end

				viewportVideoAutoplayController:forceScheduleInitialWinnerUpdate()
			end, { v24, v31, viewportVideoAutoplayController })
		end
	end

	local createElement = React.createElement
	local v22 = {
		pageContext = searchPage,
		refresh = v14,
		omniFeedItems = allItems,
		impressionsTag = "SEARCHRESULTS_FEEDITEM_IMPRESSIONS",
		scrollingFrameRef = nil,
		analyticsContext = 0,
		loadNext = 0,
		createEndOfScrollElement = 0,
		onScrollDirectionChanged = 0,
		topPadding = 0,
		sendScrollEvent = 0,
		hasNextPage = 0,
		loadMoreButtonText = 0,
		canvasTopPadding = 0,
		sduiContext = 0,
		videoPlaybackContext = 0,
		onScrollStart = 0,
		onScrollSettled = 0
	}

	if not fFlagLuaAppLayoutParamsInContext then
		setState = ref
	end

	v22.scrollingFrameRef = setState
	v22.analyticsContext = context.SearchExperienceTile
	local v23 = if v8.hasMoreRows and v10 ~= searchRetrievalStatus.Fetching and fn then fn else nil
	v22.loadNext = v23

	v22.createEndOfScrollElement = props.createEndOfScrollElement
	v22.onScrollDirectionChanged = props.onScrollDirectionChanged
	v22.topPadding = allItems[1] and allItems[1].treatmentType == omniFeedTypes.SearchGameGrid and 26 or 0

	v22.sendScrollEvent = fn2
	v22.hasNextPage = v15

	local v24 = if v15 and v10 ~= searchRetrievalStatus.Fetching and fn then v5.loadMoreButtonText else nil
	v22.loadMoreButtonText = v24

	local v25 = if fFlagAppIaScrollAway then props.canvasTopPadding else nil
	v22.canvasTopPadding = v25
	v22.sduiContext = v17

	if not fFlagLuaAppSearchResultsPageGameTileVideo then
		v18 = nil
	end

	v22.videoPlaybackContext = v18

	if not fFlagLuaAppSearchResultsPageGameTileVideo then
		v19 = nil
	end

	v22.onScrollStart = v19

	if not fFlagLuaAppSearchResultsPageGameTileVideo then
		v20 = nil
	end

	v22.onScrollSettled = v20
	return createElement(module4, v22)
end
