local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useStore = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useStore
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Stores = require(Modules.AvatarExperience.Common.Components.WidgetList.Stores)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useGetCategoryInfo = require(Modules.AvatarExperience.Catalog.Hooks.useGetCategoryInfo)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local logWidgetLoaded = AvatarExperienceAnalytics.logWidgetLoaded
local SetSearchTime = require(Modules.LuaApp.Actions.SetSearchTime)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local FFlagAXSduiWidgetsTTITracking = AvatarExperienceFlags.FFlagAXSduiWidgetsTTITracking
local FIntAXPrefetchWidgetHydrationRowsPortrait = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsPortrait
local FIntAXPrefetchWidgetHydrationRowsLandscape = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsLandscape
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local WidgetsPercievedTTIManager = AvatarExperienceTTIPerformance.WidgetsPercievedTTIManager
local OrganicTTIMilestoneManager = AvatarExperienceTTIPerformance.OrganicTTIMilestoneManager
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local fetchCatalogPage = AvatarExperienceCatalog.Sdui.fetchCatalogPage
local getCatalogConfigKey = AvatarExperienceCatalog.Sdui.getCatalogConfigKey
local getCatalogPageIdentifier = AvatarExperienceCatalog.Sdui.getCatalogPageIdentifier
local buildOrderedWidgetsFromCatalogPage = AvatarExperienceCatalog.Sdui.buildOrderedWidgetsFromCatalogPage
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore
local SduiLoadTimer = require(CorePackages.Workspace.Packages.SduiSharedUtilities).SduiLoadTimer
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local hydrateCatalogSortEntities = AvatarExperienceCatalog.Sdui.hydrateCatalogSortEntities

local function makeSelectSearchTimes(s1: string?) -- line: 77
	return function(p1) -- line: 78
		-- upvalues: s1 (copy)
		if typeof(p1.SearchTimes) == "table" and s1 then
			return p1.SearchTimes[s1]
		end

		return nil
	end
end
local function useMarketplaceResultsFetcherSdui(t1: {[any]: any}) -- line: 107
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useStore (copy), Stores (copy), useSignalState (copy), FFlagAXPrefetchOnlyWithinTTL (copy), useGetCategoryInfo (copy), GetCatalogCategoriesFromStore (copy), Utils (copy), mutedError (copy), React (copy), useSelector (copy), FFlagAXSduiWidgetsTTITracking (copy), getCatalogPageIdentifier (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), TTIPerformanceManager (copy), CatalogTilesLatencyTracker (copy), getAXMarketplaceWidgetStore (copy), SduiLoadTimer (copy), AvatarScreen (copy), getCatalogPageRequestIdStore (copy), fetchCatalogPage (copy), Promise (copy), WidgetsPercievedTTIManager (copy), sendAXStat (copy), Constants (copy), getCatalogConfigKey (copy), buildOrderedWidgetsFromCatalogPage (copy), logWidgetLoaded (copy), selectIsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsLandscape (copy), hydrateCatalogSortEntities (copy), SetHydratedWidgetData (copy), WebApi (copy), sendAXCounterV2 (copy), SetSearchTime (copy), OrganicTTIMilestoneManager (copy)
	local v50 = useDispatch()
	local v51 = useRoactService(RoactNetworking)
	local v52 = useStore()
	local v53 = Stores.getFetchMarketplaceStore(false)
	local v54 = useSignalState(v53.getFetchingMarketplace)
	local v55 = useSignalState(v53.getFetchedMarketplace)
	local v56 = if not FFlagAXPrefetchOnlyWithinTTL then nil else useSignalState(v53.getFetchedMarketplaceTimestamp)
	local setFetchingMarketplaceInProgress = v53.setFetchingMarketplaceInProgress
	local setFetchedMarketplaceCompleted = v53.setFetchedMarketplaceCompleted
	local setFetchingMarketplaceErrorOccured = v53.setFetchingMarketplaceErrorOccured
	local setFetchingMarketplaceProcessed = v53.setFetchingMarketplaceProcessed
	local v61 = useGetCategoryInfo()
	local categoryId = t1.categoryId
	local subcategoryId = t1.subcategoryId
	local v64 = GetCatalogCategoriesFromStore()
	local v65 = Utils.getCategoryInfoById(v64, categoryId, subcategoryId)

	if not v65 then
		mutedError("[useMarketplaceResultsFetcherSdui] categoryInfo is nil for categoryId: " .. tostring(categoryId) .. " and subcategoryId: " .. tostring(subcategoryId))
		v65 = v61
	end

	local SearchUuid = v65.SearchUuid
	local WidgetContext = v65.WidgetContext
	local TimeToRefresh = v65.TimeToRefresh
	local v69 = React.useCallback(function(p2) -- line: 78
		-- upvalues: SearchUuid (copy)
		if typeof(p2.SearchTimes) == "table" and SearchUuid then
			return p2.SearchTimes[SearchUuid]
		end

		return nil
	end, { SearchUuid })
	local v70 = useSelector(v69)
	local v71 = nil
	local u72 = nil

	if FFlagAXSduiWidgetsTTITracking then
		v71 = getCatalogPageIdentifier(WidgetContext or "")

		local v73 = React.useRef(nil)

		u72 = React.useCallback(function(s2: string?) -- line: 167
			-- upvalues: GetFFlagEnableCatalogTileLoadingLatency (copy), v73 (copy), TTIPerformanceManager (copy), v50 (copy), CatalogTilesLatencyTracker (copy)
			if not GetFFlagEnableCatalogTileLoadingLatency() then
				return
			end

			if s2 == nil or s2 == "" then
				return
			end

			if s2 == v73.current then
				return
			end

			v73.current = s2
			TTIPerformanceManager.Surface.Marketplace.Root.startTracking()
			v50(CatalogTilesLatencyTracker.StartTracking(s2))
		end, { v50 })
		React.useEffect(function() -- line: 185
			-- upvalues: u72 (ref), SearchUuid (copy)
			if not u72 then
				return
			end

			u72(SearchUuid)
		end, {
			SearchUuid,
			u72
		})
	end

	local v74 = React.useCallback(function(b1: boolean?) -- line: 197
		-- upvalues: getAXMarketplaceWidgetStore (copy), SduiLoadTimer (copy), AvatarScreen (copy), WidgetContext (copy), getCatalogPageIdentifier (copy), getCatalogPageRequestIdStore (copy), fetchCatalogPage (copy), Promise (copy), FFlagAXSduiWidgetsTTITracking (copy), WidgetsPercievedTTIManager (copy), sendAXStat (copy), Constants (copy), getCatalogConfigKey (copy), buildOrderedWidgetsFromCatalogPage (copy), logWidgetLoaded (copy), v52 (copy), selectIsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsLandscape (copy), hydrateCatalogSortEntities (copy), v50 (copy), v51 (copy), SetHydratedWidgetData (copy), WebApi (copy), setFetchingMarketplaceErrorOccured (copy)
		local v79 = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)
		local v80 = SduiLoadTimer.createLoadTimer(AvatarScreen.Catalog)
		local v81 = WidgetContext or ""
		local v82 = getCatalogPageIdentifier(v81)
		local v83 = getCatalogPageRequestIdStore(false)

		if b1 then
			v83.resetPageRequestId(v82)
		end

		local v84 = v83.getOrCreatePageRequestId(v82)
		local elapsed = os.clock()
		local v86 = fetchCatalogPage({
			requestId = v84,
			context = v81,
			screenSize = v79
		}, v80, if not b1 then nil else {
			forceRefresh = true
		})

		if typeof(v86) ~= "table" or typeof(v86.andThen) ~= "function" then
			return Promise.resolve()
		end

		return v86:andThen(function() -- line: 242
			-- upvalues: FFlagAXSduiWidgetsTTITracking (copy), WidgetsPercievedTTIManager (copy), sendAXStat (copy), Constants (copy), elapsed (copy), getCatalogConfigKey (copy), v81 (copy), v79 (copy), buildOrderedWidgetsFromCatalogPage (copy), v82 (copy), logWidgetLoaded (copy), v84 (copy), v52 (copy), selectIsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsPortrait (copy), FIntAXPrefetchWidgetHydrationRowsLandscape (copy), hydrateCatalogSortEntities (copy), v50 (copy), v51 (copy), SetHydratedWidgetData (copy), WebApi (copy)
			if FFlagAXSduiWidgetsTTITracking then
				WidgetsPercievedTTIManager.L3.responseReceived()
			end

			sendAXStat({
				statName = Constants.Counter.Latency.Network.FetchWidgetInfo,
				deltaMs = (os.clock() - elapsed) * 1000
			})

			local v92 = getCatalogConfigKey(v81, v79)
			local t2 = {}

			for _, v95 in (buildOrderedWidgetsFromCatalogPage(v92, v82)) do
				if v95.type ~= nil then
					table.insert(t2, v95)
				end
			end

			if #t2 > 0 then
				logWidgetLoaded(t2, v84)
			end

			local v96 = v52:getState()
			local v97 = if not selectIsPortrait(v96) then FIntAXPrefetchWidgetHydrationRowsLandscape else FIntAXPrefetchWidgetHydrationRowsPortrait

			if FFlagAXSduiWidgetsTTITracking then
				WidgetsPercievedTTIManager.L3.requestFetchHydratedWidgets()
			end

			hydrateCatalogSortEntities(v50, v51, SetHydratedWidgetData, WebApi, v97)
		end, function(p3) -- line: 290
			-- upvalues: setFetchingMarketplaceErrorOccured (copy), Promise (copy)
			setFetchingMarketplaceErrorOccured()

			return Promise.reject(p3)
		end)
	end, {
		WidgetContext,
		v52,
		v50,
		v51,
		setFetchingMarketplaceErrorOccured
	})

	return {
		fetchMarketplace = React.useCallback(function(t3: {[any]: any}?) -- line: 305
			-- upvalues: FFlagAXSduiWidgetsTTITracking (copy), WidgetsPercievedTTIManager (copy), setFetchingMarketplaceInProgress (copy), u72 (ref), SearchUuid (copy), v70 (copy), TimeToRefresh (copy), sendAXCounterV2 (copy), Constants (copy), v50 (copy), SetSearchTime (copy), v74 (copy), Promise (copy), OrganicTTIMilestoneManager (copy), setFetchedMarketplaceCompleted (copy), setFetchingMarketplaceProcessed (copy)
			if FFlagAXSduiWidgetsTTITracking then
				WidgetsPercievedTTIManager.L2.primaryDataStarted()
			end

			setFetchingMarketplaceInProgress()

			if u72 then
				u72(SearchUuid)
			end

			local v88 = t3 ~= nil and t3.forceRefresh == true
			local v89 = not v88 and (v70 ~= nil and (TimeToRefresh ~= nil and (TimeToRefresh >= 0 and tick() - v70 > TimeToRefresh)))

			if v89 then
				sendAXCounterV2(Constants.Counter.CatalogRefresh.StaleResults)
			end

			local v90 = v88 or v89

			v50(SetSearchTime(SearchUuid, tick()))

			if FFlagAXSduiWidgetsTTITracking then
				WidgetsPercievedTTIManager.L3.networkFetch()
			end

			local t4 = { v74(v90) }

			Promise.all(t4):andThen(function() -- line: 360
				-- upvalues: FFlagAXSduiWidgetsTTITracking (copy), WidgetsPercievedTTIManager (copy), OrganicTTIMilestoneManager (copy), setFetchedMarketplaceCompleted (copy)
				if not FFlagAXSduiWidgetsTTITracking then
					WidgetsPercievedTTIManager.L2.dataProcessingStarted()
					OrganicTTIMilestoneManager.L2.dataProcessingStarted()
				end

				setFetchedMarketplaceCompleted()

				if not FFlagAXSduiWidgetsTTITracking then
					WidgetsPercievedTTIManager.L2.dataProcessingCompleted()
					OrganicTTIMilestoneManager.L2.dataProcessingCompleted()
				end
			end):catch(function(p4) -- line: 372
				-- upvalues: sendAXCounterV2 (copy), Constants (copy)
				local ok, result = pcall(function() -- line: 373
					-- upvalues: p4 (copy)
					return (string.sub(tostring(p4), 1, 100))
				end)

				sendAXCounterV2(Constants.Counter.Catalog.Errors.FetchMarketplaceSduiError, {
					error = not ok and "unknown" or result
				})
			end)
			Promise.allSettled(t4):finally(function() -- line: 382
				-- upvalues: FFlagAXSduiWidgetsTTITracking (copy), WidgetsPercievedTTIManager (copy), setFetchingMarketplaceProcessed (copy)
				if FFlagAXSduiWidgetsTTITracking then
					WidgetsPercievedTTIManager.L2.dataProcessingStarted()
				end

				if setFetchingMarketplaceProcessed then
					setFetchingMarketplaceProcessed()
				end

				if FFlagAXSduiWidgetsTTITracking then
					WidgetsPercievedTTIManager.L2.dataProcessingCompleted()
				end
			end)

			if not FFlagAXSduiWidgetsTTITracking then
				WidgetsPercievedTTIManager.L3.networkFetch()
				OrganicTTIMilestoneManager.L3.networkFetch()
			end
		end, {
			SearchUuid,
			v70,
			TimeToRefresh,
			setFetchingMarketplaceInProgress,
			setFetchedMarketplaceCompleted,
			setFetchingMarketplaceProcessed,
			v50,
			v74,
			u72
		}),
		hasFetched = v55,
		isFetching = v54,
		fetchedMarketplaceTimestamp = if not FFlagAXPrefetchOnlyWithinTTL then nil else v56,
		searchUuid = SearchUuid,
		identifier = v71
	}
end

return useMarketplaceResultsFetcherSdui
