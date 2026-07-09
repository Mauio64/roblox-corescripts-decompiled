local CorePackages = game:GetService("CorePackages")
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local DiscoveryAnalytics = require(CorePackages.Workspace.Packages.DiscoveryAnalytics)
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local useCollectionLayoutConfig = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionLayoutConfig
local FetchStatusRodux = require(CorePackages.Workspace.Packages.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local useCurrentSquadId = require(CorePackages.Workspace.Packages.SquadsCore.Hooks).useCurrentSquadId
local SearchLandingPageSurface = require(CorePackages.Workspace.Packages.DiscoveryTypes).SearchLandingPageSurface
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SearchConstants = Modules.Personalization.Search.SearchConstants
local SearchLandingPageSession = Modules.Personalization.Sessions.SearchLandingPageSession
local ApiFetchSearchLandingPage = Modules.LuaApp.Thunks.Search.ApiFetchSearchLandingPage
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local OmniFeedViewLoadMore = require(Modules2.Personalization.OmniFeed.FeedViews.OmniFeedViewLoadMore)
local setSearchLandingPageSessionInfo = require(Modules2.Personalization.Sessions.setSearchLandingPageSessionInfo)
local SearchLandingPageSkeleton = require(script.Parent.SearchLandingPageSkeleton)
local FFlagLuaAppLayoutParamsInContext = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppLayoutParamsInContext
local SearchLandingPage2 = AppPage.SearchLandingPage

function SearchLandingPage(t1: {[any]: any}) -- line: 57
	-- upvalues: useDispatch (copy), useDesignTokens (copy), useCurrentSquadId (copy), useRoactService (copy), RoactNetworking (copy), AppSessionService (copy), SearchConstants (copy), React (copy), FFlagLuaAppLayoutParamsInContext (copy), useSelector (copy), SearchLandingPage2 (copy), setSearchLandingPageSessionInfo (copy), ApiFetchSearchLandingPage (copy), SearchLandingPageSession (copy), SearchLandingPageSurface (copy), useCollectionLayoutConfig (copy), ServerDrivenUi (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), SearchLandingPageSkeleton (copy), Focusable (copy), OmniFeedViewLoadMore (copy), AppPage (copy), DiscoveryAnalytics (copy)
	local v31 = useDispatch()
	local v32 = useDesignTokens()
	local v33 = useCurrentSquadId()
	local v34 = useRoactService(RoactNetworking)
	local v35 = useRoactService(AppSessionService)
	local v36 = SearchConstants.getSearchTokens(v32)
	local v37 = t1.scrollingFrameRef or React.useRef(nil)
	local v38 = nil
	local v39 = nil

	if FFlagLuaAppLayoutParamsInContext then
		local v40

		v38, v40 = React.useState(nil)

		local u41 = v40

		v39 = React.useCallback(function(p1) -- line: 70
			-- upvalues: v37 (copy), u41 (ref)
			v37.current = p1
			u41(p1)
		end, {})
	end

	local v42 = useSelector(function(p2) -- line: 77
		-- upvalues: SearchLandingPage2 (copy)
		return p2.Personalization.OrderedOmniItems[SearchLandingPage2] or nil
	end)
	local v43 = v42 and v42.allItems or {}
	local v44 = React.useCallback(function() -- line: 84
		-- upvalues: setSearchLandingPageSessionInfo (copy), v35 (copy), v33 (copy), v31 (copy), ApiFetchSearchLandingPage (copy), v34 (copy), SearchLandingPageSession (copy), SearchLandingPageSurface (copy)
		setSearchLandingPageSessionInfo(v35, true)

		if v33 ~= "" and v33 ~= nil then
			return v31(ApiFetchSearchLandingPage(v34, SearchLandingPageSession:Get(), SearchLandingPageSurface.Party))
		end

		return v31(ApiFetchSearchLandingPage(v34, SearchLandingPageSession:Get()))
	end, {
		v31,
		v34,
		SearchLandingPageSession,
		v33,
		v35
	})
	local onAbsoluteContentSizeChanged = t1.onAbsoluteContentSizeChanged
	local v46 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(v38)
	local v47 = ServerDrivenUi.useSduiContextFromRoduxAndProcessConfigs(SearchLandingPage2, if not FFlagLuaAppLayoutParamsInContext then nil else v46)
	local v48 = useSelector(function(p3) -- line: 115
		-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), SearchLandingPageSession (copy), RetrievalStatus (copy)
		return p3.Personalization[FetchStatusReducer.key][FetchStatusNamespace.SearchLandingPage][SearchLandingPageSession:Get()] or RetrievalStatus.NotStarted
	end)

	if React.useMemo(function() -- line: 120
		-- upvalues: v43 (copy), RetrievalStatus (copy), v48 (copy)
		if next(v43) ~= nil then
			return RetrievalStatus.Done
		end

		return v48
	end, {
		v48,
		v43
	}) ~= RetrievalStatus.Done then
		return React.createElement(SearchLandingPageSkeleton, {
			Size = t1.size,
			LayoutOrder = t1.layoutOrder,
			onAbsoluteContentSizeChanged = onAbsoluteContentSizeChanged,
			topPadding = v36.searchLandingPage.topPadding,
			bottomPadding = v36.searchLandingPage.bottomPadding,
			isCompactView = t1.isCompactView,
			defaultContainerSize = t1.defaultContainerSize
		})
	end

	return React.createElement(Focusable.Frame, {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = t1.layoutOrder,
		Size = t1.size or UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = t1.position or UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = v36.backgroundContainer.backgroundColor3,
		BackgroundTransparency = v36.backgroundContainer.backgroundTransparency
	}, {
		SearchOmniAutocompleteFeedView = React.createElement(OmniFeedViewLoadMore, {
			impressionsTag = "SEARCHLANDINGPAGE_FEEDITEM_IMPRESSIONS",
			createEndOfScrollElement = false,
			scrollBarThickness = 0,
			pageContext = AppPage.SearchLandingPage,
			refresh = v44,
			omniFeedItems = v43,
			scrollingFrameRef = if not FFlagLuaAppLayoutParamsInContext then v37 else v39,
			analyticsContext = DiscoveryAnalytics.Constants.Context.ExperienceTile,
			topPadding = v36.searchLandingPage.topPadding,
			bottomPadding = v36.searchLandingPage.bottomPadding,
			onAbsoluteContentSizeChanged = onAbsoluteContentSizeChanged,
			sduiContext = v47,
			defaultContainerSize = t1.defaultContainerSize
		})
	})
end

return SearchLandingPage
