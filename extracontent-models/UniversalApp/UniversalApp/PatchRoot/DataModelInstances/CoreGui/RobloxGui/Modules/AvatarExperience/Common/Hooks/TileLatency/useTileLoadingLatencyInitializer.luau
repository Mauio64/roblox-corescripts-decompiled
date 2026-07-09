local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useGetCurrentCategoryNames = require(Modules.AvatarExperience.Catalog.Hooks.useGetCurrentCategoryNames)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local MemStorageService = game:GetService("MemStorageService")
local sendAXStat = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXStat
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local WidgetsPercievedTTIManager = AvatarExperienceTTIPerformance.WidgetsPercievedTTIManager
local OrganicTTIMilestoneManager = AvatarExperienceTTIPerformance.OrganicTTIMilestoneManager

local function fireTileLoadingLatencyTracker(p1, b1: boolean?, b2: boolean?) -- line: 28
	-- upvalues: CatalogTilesLatencyTracker (copy), Constants (copy), WidgetsPercievedTTIManager (copy), OrganicTTIMilestoneManager (copy), TTIPerformanceManager (copy), sendAXStat (copy), MemStorageService (copy)
	if p1.trackerStartTime then
		local trackerPerceivedStartTime = p1.trackerPerceivedStartTime
		local elapsed = os.clock()

		if b1 and not b2 then
			p1.dispatch(CatalogTilesLatencyTracker.EndTracking(p1.searchUuid, elapsed))
		end

		local v30 = (elapsed - p1.trackerStartTime) * 1000
		local v31 = if not trackerPerceivedStartTime then nil else (elapsed - trackerPerceivedStartTime) * 1000
		local v32 = if not b1 then Constants.Counter.Latency.Organic.Tiles else Constants.Counter.Latency.Organic.Thumbnails

		if b2 then
			v32 = if not b1 then Constants.Counter.Latency.Widget.Tiles else Constants.Counter.Latency.Widget.Thumbnails
		end

		local t1 = {
			Page = p1.currentPageName,
			OpaquePage = p1.opaquePageName,
			ColdStart = p1.coldStart,
			Category = p1.currentCategory,
			Subcategory = p1.currentSubcategory
		}
		local t2 = {
			page = p1.currentPageName,
			opaquePage = p1.opaquePageName,
			coldStart = p1.coldStart,
			category = p1.currentCategory,
			subcategory = p1.currentSubcategory
		}

		if b2 then
			if b1 then
				WidgetsPercievedTTIManager.L2.surfaceReady()
			else
				WidgetsPercievedTTIManager.L2.functionallyReady()
			end
		end

		if not b2 then
			if b1 then
				OrganicTTIMilestoneManager.L2.surfaceReady()
			else
				OrganicTTIMilestoneManager.L2.functionallyReady()
			end
		end

		local Root = TTIPerformanceManager.Surface.Marketplace.Root

		Root.endTracking(v32, t2)

		if v31 then
			Root.endPerceivedTracking(v32, t2)
		end

		sendAXStat({
			statName = v32,
			deltaMs = v30,
			metaData = t1
		})

		if v31 then
			sendAXStat({
				statName = v32 .. "_Percieved",
				deltaMs = v31,
				metaData = t1
			})
		end

		if MemStorageService:GetItem(Constants.MemStorageKeys.ColdStart.CatalogAndCatalogSearch) and b1 then
			MemStorageService:SetItem(Constants.MemStorageKeys.ColdStart.CatalogAndCatalogSearch, "false")
		end
	end
end
local function perceivedStartTimeSelector(p2) -- line: 129
	return p2.AvatarExperience.Catalog.ResultsList.perceivedStartTime or nil
end
local function useTileLoadingLatencyInitializer(s1: string) -- line: 133
	-- upvalues: useAvatarRoute (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useGetCurrentCategoryNames (copy), useSelector (copy), getUseSelectorDeepEquals (copy), perceivedStartTimeSelector (copy), MemStorageService (copy), Constants (copy), usePrevious (copy), React (copy), AvatarScreen (copy), fireTileLoadingLatencyTracker (copy)
	local v38 = useAvatarRoute()
	local name = v38.current.name
	local v40 = if not v38.opaque then nil else v38.opaque.name
	local v41 = useDispatch()
	local v42 = useRoactService(Analytics)
	local v43 = useGetCurrentCategoryNames()
	local v44 = useSelector(function(p3) -- line: 140
		-- upvalues: s1 (copy)
		return p3.AvatarExperience.Catalog.ResultsList[s1] and (not not p3.AvatarExperience.Catalog.ResultsList[s1].tileLoadingLatency and p3.AvatarExperience.Catalog.ResultsList[s1].tileLoadingLatency.thumbnails) or nil
	end, getUseSelectorDeepEquals())
	local v45 = useSelector(function(p4) -- line: 146
		-- upvalues: s1 (copy)
		return p4.AvatarExperience.Catalog.ResultsList[s1] and (not not p4.AvatarExperience.Catalog.ResultsList[s1].tileLoadingLatency and p4.AvatarExperience.Catalog.ResultsList[s1].tileLoadingLatency.startTime) or nil
	end, getUseSelectorDeepEquals())
	local v46 = useSelector(perceivedStartTimeSelector, getUseSelectorDeepEquals())
	local v47 = useSelector(function(p5) -- line: 153
		-- upvalues: s1 (copy)
		return p5.AvatarExperience.Catalog.ResultsList[s1] and (not not p5.AvatarExperience.Catalog.ResultsList[s1].tileLoadingLatency and p5.AvatarExperience.Catalog.ResultsList[s1].tileLoadingLatency.endTime) or nil
	end, getUseSelectorDeepEquals())
	local v48 = MemStorageService:GetItem(Constants.MemStorageKeys.ColdStart.CatalogAndCatalogSearch) ~= "false"
	local v49 = usePrevious(v44)
	local v50, v51 = React.useState("")
	local v52, v53 = React.useState("")

	React.useEffect(function() -- line: 168
		-- upvalues: v43 (copy), name (copy), AvatarScreen (copy), v51 (copy), v53 (copy)
		if not v43 then
			return
		end

		if name == AvatarScreen.CatalogSearch then
			v51(v43.catalogSearchCategory)
			v53(v43.catalogSearchSubcategory)

			return
		end

		v51(v43.catalogCategory)
		v53(v43.catalogSubcategory)
	end, {
		name,
		v43
	})

	return {
		dispatch = v41,
		analytics = v42,
		trackerLoadedThumbnails = v44,
		trackerStartTime = v45,
		trackerEndTime = v47,
		coldStart = v48,
		prevImpressionResults = v49,
		currentCategory = v50,
		setCurrentCategory = v51,
		currentSubcategory = v52,
		setCurrentSubcategory = v53,
		currentPageName = name,
		searchUuid = s1,
		opaquePageName = v40,
		fireTileLoadingLatencyTracker = fireTileLoadingLatencyTracker,
		trackerPerceivedStartTime = v46
	}
end

return useTileLoadingLatencyInitializer
