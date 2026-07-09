local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch

require(CorePackages.Workspace.Packages.AppCommonLib)

local feedScroll = require(CorePackages.Workspace.Packages.ScrollTelemetry).feedScroll
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local Context = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Constants.Context
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local useCollectionLayoutConfig = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionLayoutConfig
local OmniFeedTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedTypes
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local FetchDataWithErrorToasts = Modules.LuaApp.Thunks.FetchDataWithErrorToasts
local SearchRetrievalStatus = Modules.LuaApp.Enum.SearchRetrievalStatus
local ApiFetchGameSearchResults = Modules.LuaApp.Thunks.Search.ApiFetchGameSearchResults
local PaginationMethod = Modules.LuaApp.Enum.PaginationMethod
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local OmniFeedViewLoadMore = require(Modules2.Personalization.OmniFeed.FeedViews.OmniFeedViewLoadMore)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext

return function(t1: {[any]: any}) -- line: 48
	-- upvalues: AppPage (copy), FFlagLuaAppLayoutParamsInContext (copy), React (copy), useLocalization (copy), useRoactService (copy), RoactNetworking (copy), AppEventIngestService (copy), useSelector (copy), useDispatch (copy), FetchDataWithErrorToasts (copy), ApiFetchGameSearchResults (copy), mutedError (copy), feedScroll (copy), PaginationMethod (copy), useCollectionLayoutConfig (copy), ServerDrivenUi (copy), OmniFeedViewLoadMore (copy), Context (copy), SearchRetrievalStatus (copy), OmniFeedTypes (copy), FFlagAppIaScrollAway (copy)
	local SearchPage = AppPage.SearchPage
	local v28 = if FFlagLuaAppLayoutParamsInContext then nil else React.useRef(nil)
	local u29 = nil
	local v30 = nil

	if FFlagLuaAppLayoutParamsInContext then
		local v31

		v31, v30 = React.useState(nil)
		u29 = v31
	end

	local v32 = useLocalization({
		loadMoreButtonText = "Search.GlobalSearch.Action.LoadMore"
	})
	local searchUuid = t1.searchUuid
	local v34 = useRoactService(RoactNetworking)
	local v35 = useRoactService(AppEventIngestService)
	local v36 = useSelector(function(p1) -- line: 63
		-- upvalues: searchUuid (copy)
		return p1.Search.SearchesInGames[searchUuid]
	end)
	local v37 = useSelector(function(p2) -- line: 66
		-- upvalues: searchUuid (copy)
		if searchUuid and p2.SearchesParameters[searchUuid] then
			return p2.SearchesParameters[searchUuid].searchKeyword
		end

		return nil
	end)
	local v38 = useSelector(function(p3) -- line: 72
		-- upvalues: searchUuid (copy)
		return p3.RequestsStatus.SearchesInGamesStatus[searchUuid]
	end)
	local v39 = useSelector(function(p4) -- line: 75
		-- upvalues: SearchPage (copy), searchUuid (copy)
		return p4.Personalization.OrderedOmniItems[SearchPage] and p4.Personalization.OrderedOmniItems[SearchPage][searchUuid] or nil
	end)
	local v40 = v39 and v39.allItems or {}
	local v41 = useSelector(function(p5) -- line: 81
		return p5.ScreenSize
	end)
	local v42 = useDispatch()

	local function v43() -- line: 86
		-- upvalues: v42 (copy), FetchDataWithErrorToasts (copy), ApiFetchGameSearchResults (copy), v34 (copy), v37 (copy), t1 (copy)
		return v42(FetchDataWithErrorToasts(ApiFetchGameSearchResults(v34, {
			isAppend = true,
			searchKeyword = v37,
			searchUuid = t1.searchUuid,
			omniSearchUuid = t1.omniSearchUuid
		})))
	end

	local v44 = React.useCallback(function() -- line: 94
		-- upvalues: v42 (copy), FetchDataWithErrorToasts (copy), ApiFetchGameSearchResults (copy), v34 (copy), v37 (copy), searchUuid (copy), t1 (copy)
		return v42(FetchDataWithErrorToasts(ApiFetchGameSearchResults(v34, {
			isAppend = false,
			searchKeyword = v37,
			searchUuid = searchUuid,
			omniSearchUuid = t1.omniSearchUuid
		})))
	end, {
		v42,
		v34,
		v37,
		searchUuid,
		t1.omniSearchUuid
	})
	local v45 = t1.paginationMethod == PaginationMethod.Button and v36.hasMoreRows
	local v46 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(u29)
	local v47 = ServerDrivenUi.useSduiContextFromRoduxAndProcessConfigs(SearchPage, if not FFlagLuaAppLayoutParamsInContext then nil else v46, `{ SearchPage }_{ searchUuid }`)

	return React.createElement(OmniFeedViewLoadMore, {
		impressionsTag = "SEARCHRESULTS_FEEDITEM_IMPRESSIONS",
		pageContext = SearchPage,
		refresh = v44,
		omniFeedItems = v40,
		scrollingFrameRef = if not FFlagLuaAppLayoutParamsInContext then v28 else v30,
		analyticsContext = Context.SearchExperienceTile,
		loadNext = v36.hasMoreRows and (v38 ~= SearchRetrievalStatus.Fetching and v43) or nil,
		createEndOfScrollElement = t1.createEndOfScrollElement,
		onScrollDirectionChanged = t1.onScrollDirectionChanged,
		topPadding = (not v40[1] or v40[1].treatmentType ~= OmniFeedTypes.SearchGameGrid) and 0 or 26,
		sendScrollEvent = function(n1: number, n2: number, n3: number) -- line: 103
			-- upvalues: FFlagLuaAppLayoutParamsInContext (copy), u29 (ref), v28 (copy), mutedError (copy), v41 (copy), feedScroll (copy), v35 (copy), SearchPage (copy)
			local v56 = if not FFlagLuaAppLayoutParamsInContext then v28.current else u29
			local v57 = if not v56 then nil else v56.ScrollingDirection

			if v57 then
				local n4 = 0

				if v56 then
					if v57 == Enum.ScrollingDirection.X then
						n4 = v56.AbsoluteSize.X
					elseif v57 == Enum.ScrollingDirection.Y then
						n4 = v56.AbsoluteSize.Y
					else
						mutedError(`Direction { v57.Name } is an unsupported option for feedScroll event`)
					end
				end

				local t2 = {
					distance = n1,
					screenSizeX = v41.X,
					screenSizeY = v41.Y,
					scrollAreaSize = n4,
					scrollDepth = if not (n4 > 0) then nil else n1 / n4,
					startDepth = if not (n4 > 0) then nil else n3 / n4,
					startPos = n3,
					scrollDuration = n2
				}

				feedScroll(v35, SearchPage, v57, t2)
			end
		end,
		hasNextPage = v45,
		loadMoreButtonText = if not v45 or (v38 == SearchRetrievalStatus.Fetching or not v43) then nil else v32.loadMoreButtonText,
		canvasTopPadding = if not FFlagAppIaScrollAway then nil else t1.canvasTopPadding,
		sduiContext = v47
	})
end
