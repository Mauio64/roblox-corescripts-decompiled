local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local UIBlox = require(CorePackages.Packages.UIBlox)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Promise = require(CorePackages.Packages.Promise)
local feedScroll = require(CorePackages.Workspace.Packages.ScrollTelemetry).feedScroll
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local RoactAnalytics = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalytics
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local RetrievalStatus2 = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local useCollectionLayoutConfig = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionLayoutConfig
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local DiscoverPageSession = Modules.Personalization.Sessions.DiscoverPageSession
local FetchGamesPageData = Modules.LuaApp.Thunks.FetchGamesPageData
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local PageSessionManager = require(Modules2.Personalization.Sessions.PageSessionManager)
local useLocalization = require(Modules2.LuaApp.Hooks.useLocalization)
local AddLocalOmniItems = require(Modules2.Personalization.OmniFeed.DataStore.AddLocalOmniItems)
local RefreshSiteAlertInfo = require(Modules2.LuaApp.Actions.RefreshSiteAlertInfo)
local OmniFeedViewLoadMore = require(Modules2.Personalization.OmniFeed.FeedViews.OmniFeedViewLoadMore)
local v34 = game:DefineFastFlag("LuaAppLogDiscoverPageLayerExposure", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppChartsStickyHeader = SharedFlags.FFlagLuaAppChartsStickyHeader
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = SharedFlags.FFlagLuaAppChartsResetFetchingStatusOnFilterChange
local FFlagLuaAppFixChartsRenderOnFail = SharedFlags.FFlagLuaAppFixChartsRenderOnFail
local FFlagLuaAppCompositionCharts = SharedFlags.FFlagLuaAppCompositionCharts
local FFlagLuaAppScrollTelemetryIntegration = SharedFlags.FFlagLuaAppScrollTelemetryIntegration
local Games = AppPage.Games
local v44 = if not FFlagLuaAppFixChartsRenderOnFail then nil else function(t1: {[any]: any}) -- line: 58
	-- upvalues: useLocalization (copy), React (copy), EmptyState (copy)
	local v46 = useLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet"
	})
	local v47 = React.useCallback(function() -- line: 63
		-- upvalues: t1 (copy)
		t1.fetchGamesPageData()
	end, { t1.fetchGamesPageData })

	return React.createElement(EmptyState, {
		onActivated = v47,
		text = v46.failedMessage
	})
end

return function(t2: {[any]: any}) -- line: 81
	-- upvalues: FFlagAppIaScrollAway (copy), useRoactService (copy), AppSessionService (copy), RoactNetworking (copy), RoactAnalytics (copy), AppEventIngestService (copy), useNavigation (copy), FFlagLuaAppLayoutParamsInContext (copy), React (copy), useSelector (copy), Games (copy), useDispatch (copy), Promise (copy), FetchGamesPageData (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), RetrievalStatus2 (copy), AddLocalOmniItems (copy), RefreshSiteAlertInfo (copy), feedScroll (copy), RoactNavigation (copy), v34 (copy), IXPService (copy), AppUserLayers (copy), useCollectionLayoutConfig (copy), ServerDrivenUi (copy), PageSessionManager (copy), SessionType (copy), DiscoverPageSession (copy), LoadingStateContainer (copy), RetrievalStatus (copy), OmniFeedViewLoadMore (copy), FFlagLuaAppChartsStickyHeader (copy), FFlagLuaAppCompositionCharts (copy), FFlagLuaAppScrollTelemetryIntegration (copy), FFlagLuaAppFixChartsRenderOnFail (copy), v44 (copy), useLocalization (copy), EmptyState (copy)
	local v49 = if not FFlagAppIaScrollAway then nil else t2.canvasTopPadding
	local v50 = useRoactService(AppSessionService)
	local v51 = useRoactService(RoactNetworking)
	local v52 = useRoactService(RoactAnalytics)
	local v53 = useRoactService(AppEventIngestService)
	local v54 = useNavigation()
	local v55 = if FFlagLuaAppLayoutParamsInContext then nil else React.useRef(nil)
	local u56 = nil
	local u57 = nil

	if FFlagLuaAppLayoutParamsInContext then
		local v58, v59 = React.useState(nil)

		u56 = v58
		u57 = v59
	end

	local v60 = useSelector(function(p1) -- line: 94
		return p1.Startup.GamesPageDataStatus
	end)
	local v61 = useSelector(function(p2) -- line: 97
		-- upvalues: Games (copy)
		return p2.Personalization.OrderedOmniItems[Games]
	end)
	local v62 = useDispatch()
	local v63 = useSelector(function(p3) -- line: 101
		return p3.ScreenSize
	end)
	local v64 = useSelector(function(p4) -- line: 105
		return p4.Personalization.DiscoveryNextPageId
	end)
	local v65 = React.useRef(nil)
	local v66 = React.useCallback(function(s1: string?) -- line: 110
		-- upvalues: v65 (copy), Promise (copy), v62 (copy), FetchGamesPageData (copy), v51 (copy), v52 (copy)
		if s1 and s1 == v65.current then
			return Promise.reject("Already fetching")
		end

		v65.current = s1

		return (v62(FetchGamesPageData(v51, v52, s1)))
	end, {
		v62,
		v51,
		v52
	})

	local function v67() -- line: 123
		-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), v60 (copy), RetrievalStatus2 (copy), v64 (copy), v66 (copy), Promise (copy)
		if ((if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then v60 else v60.status)) ~= RetrievalStatus2.Fetching and (v64 and v64 ~= "") then
			return v66(v64)
		end

		return Promise.reject("Cannot load page")
	end

	local v68 = React.useCallback(function() -- line: 143
		-- upvalues: v62 (copy), RefreshSiteAlertInfo (copy), v66 (copy)
		v62(RefreshSiteAlertInfo())

		return v66()
	end, {
		v62,
		v66
	})

	local function v69(n1: number, n2: number, n3: number) -- line: 148
		-- upvalues: FFlagLuaAppLayoutParamsInContext (copy), u56 (ref), v55 (copy), v63 (copy), feedScroll (copy), v53 (copy), Games (copy)
		local ScrollingDirectionY = Enum.ScrollingDirection.Y

		if ScrollingDirectionY then
			local v89

			if FFlagLuaAppLayoutParamsInContext then
				v89 = u56 and u56.AbsoluteSize.Y or 0
			else
				v89 = 0

				if v55.current then
					v89 = v55.current.AbsoluteSize.Y
				end
			end

			local t3 = {
				distance = n1,
				screenSizeX = v63.X,
				screenSizeY = v63.Y,
				scrollAreaSize = v89,
				scrollDepth = if not (v89 > 0) then nil else n1 / v89,
				startDepth = if not (v89 > 0) then nil else n3 / v89,
				startPos = n3,
				scrollDuration = n2
			}

			feedScroll(v53, Games, ScrollingDirectionY, t3)
		end
	end

	local v70 = v61 and v61.allItems or {}
	local v71 = not not v61 and (v61.hasLocalItems or false)

	React.useEffect(function() -- line: 180
		-- upvalues: v71 (copy), v62 (copy), AddLocalOmniItems (copy), Games (copy)
		if not v71 then
			v62(AddLocalOmniItems({}, Games))
		end
	end, {
		v71,
		function(p5) -- line: 140
			-- upvalues: v62 (copy), AddLocalOmniItems (copy), Games (copy)
			v62(AddLocalOmniItems(p5, Games))
		end
	})

	local u72 = nil
	local u74

	if FFlagLuaAppChartsResetFetchingStatusOnFilterChange then
		local status = v60.status

		u74 = if status ~= RetrievalStatus2.Fetching and status ~= RetrievalStatus2.Failed or (v60.isRefreshFetch or (not v70 or not (#v70 > 0))) then status else RetrievalStatus2.Done
	else
		local v75, v76 = React.useState(v60)

		u74 = v75
		u72 = v76
	end

	React.useEffect(function() -- line: 200
		-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), v60 (copy), RetrievalStatus2 (copy), v66 (copy), v54 (copy), RoactNavigation (copy), u74 (ref), u72 (ref)
		if ((if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then v60 else v60.status)) == RetrievalStatus2.NotStarted then
			v66()
		end

		local v91 = v54.addListener(RoactNavigation.Events.WillFocus, function() -- line: 211
			-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), v60 (copy), RetrievalStatus2 (copy), v66 (copy)
			if ((if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then v60 else v60.status)) == RetrievalStatus2.NotStarted then
				v66()
			end
		end)

		if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange and u74 ~= RetrievalStatus2.Done then
			u72(v60)
		end

		return function() -- line: 227
			-- upvalues: v91 (copy)
			if v91 ~= nil then
				v91.remove()
			end
		end
	end, {
		v54,
		v60,
		if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then u74 else nil
	})

	if v34 then
		React.useEffect(function() -- line: 239
			-- upvalues: IXPService (copy), AppUserLayers (copy)
			IXPService:LogUserLayerExposure(AppUserLayers.DiscoverPageLayer)
		end, {})
	end

	local v77 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(u56)
	local v78 = ServerDrivenUi.useSduiContextFromRoduxAndProcessConfigs(Games, if not FFlagLuaAppLayoutParamsInContext then nil else v77)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		PageSessionManager = React.createElement(PageSessionManager, {
			appPage = Games,
			setPageSession = function() -- line: 259
				-- upvalues: v50 (copy), SessionType (copy), DiscoverPageSession (copy)
				if v50 ~= nil then
					v50:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.DiscoverPageSessionInfo, SessionType.StructuralIdentifier.DiscoverPageSessionInfo)
					v50:SetMetadata(SessionType.StructuralIdentifier.DiscoverPageSessionInfo, SessionType.Metadata.DiscoverPage.DiscoverSessionId, DiscoverPageSession:Get())
				end
			end
		}),
		LoadingStateContainer = React.createElement(LoadingStateContainer, {
			dataStatus = RetrievalStatus.fromRawValue(u74),
			onRetry = v66,
			renderOnLoaded = function() -- line: 278
				-- upvalues: React (copy), OmniFeedViewLoadMore (copy), Games (copy), v68 (copy), v70 (copy), FFlagLuaAppLayoutParamsInContext (copy), u57 (ref), v55 (copy), v64 (copy), v67 (copy), v69 (copy), FFlagAppIaScrollAway (copy), v49 (copy), v78 (copy), FFlagLuaAppChartsStickyHeader (copy), t2 (copy), FFlagLuaAppCompositionCharts (copy), FFlagLuaAppScrollTelemetryIntegration (copy)
				return React.createElement(OmniFeedViewLoadMore, {
					impressionsTag = "GAMESFEEDITEM_IMPRESSIONS",
					analyticsContext = "GamesOmniFeed",
					pageContext = Games,
					refresh = v68,
					omniFeedItems = v70,
					scrollingFrameRef = if not FFlagLuaAppLayoutParamsInContext then v55 else u57,
					hasNextPage = v64 and v64 ~= "",
					loadNext = v67 or nil,
					sendScrollEvent = v69,
					canvasTopPadding = if not FFlagAppIaScrollAway then nil else v49,
					sduiContext = v78,
					topPadding = if not FFlagLuaAppChartsStickyHeader then nil else t2.topPadding,
					appCompositionEnabled = not not FFlagLuaAppCompositionCharts or nil,
					scrollPerformanceIntervalName = if not FFlagLuaAppScrollTelemetryIntegration then nil else "LuaApp_Charts_Scroll"
				})
			end,
			renderOnFailed = not FFlagLuaAppFixChartsRenderOnFail and function() -- line: 306
				-- upvalues: useLocalization (copy), React (copy), EmptyState (copy), v66 (copy)
				return function(_) -- line: 307
					-- upvalues: useLocalization (copy), React (copy), EmptyState (copy), v66 (copy)
					local v93 = useLocalization({
						failedMessage = "Feature.EmptyStatePage.Message.NoInternet"
					})

					return React.createElement(EmptyState, {
						onActivated = v66,
						text = v93.failedMessage
					})
				end
			end or function() -- line: 301
				-- upvalues: React (copy), v44 (copy), v66 (copy)
				return React.createElement(v44, {
					fetchGamesPageData = v66
				})
			end
		})
	})
end
