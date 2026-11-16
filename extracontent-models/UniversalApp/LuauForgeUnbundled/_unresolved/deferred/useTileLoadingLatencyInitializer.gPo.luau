local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fvF")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module2 = require("@luauforge/bundled/eeH")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local module4 = require("@luauforge/deferred/gPp")
local module5 = require("@luauforge/bundled/dSV")
local module6 = require("@luauforge/bundled/dMx")
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local MemStorageService = game:GetService("MemStorageService")
local sendAXStat = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXStat

local fFlagAXRemoveLegacyTileLatencyStats = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRemoveLegacyTileLatencyStats
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local module7 = require("@luauforge/bundled/ggZ")
local ttiPerformanceManager = module7.TTIPerformanceManager
local ttiMetricNames = module7.TTIMetricNames
local widgetsPercievedTTIManager = module7.WidgetsPercievedTTIManager
local organicTTIMilestoneManager = module7.OrganicTTIMilestoneManager

local function fireTileLoadingLatencyTracker(data, p2, p3)
	if data.trackerStartTime then
		local trackerPerceivedStartTime = data.trackerPerceivedStartTime

		local now = os.clock()

		if p2 and not p3 then
			data.dispatch(module5.EndTracking(data.searchUuid, now))
		end

		local v5 = (now - data.trackerStartTime) * 1000

		local v6 = if trackerPerceivedStartTime then (now - trackerPerceivedStartTime) * 1000 else nil
		local v7

		if p2 then
			if fFlagAXRemoveLegacyTileLatencyStats then
				v7 = ttiMetricNames.Marketplace.OrganicThumbnails
			else
				v7 = module6.Counter.Latency.Organic.Thumbnails
			end
		elseif fFlagAXRemoveLegacyTileLatencyStats then
			v7 = ttiMetricNames.Marketplace.OrganicTiles
		else
			v7 = module6.Counter.Latency.Organic.Tiles
		end

		if p3 then
			if p2 then
				if fFlagAXRemoveLegacyTileLatencyStats then
					v7 = ttiMetricNames.Marketplace.WidgetThumbnails
				else
					v7 = module6.Counter.Latency.Widget.Thumbnails
				end
			elseif fFlagAXRemoveLegacyTileLatencyStats then
				v7 = ttiMetricNames.Marketplace.WidgetTiles
			else
				v7 = module6.Counter.Latency.Widget.Tiles
			end
		end

		local v8 = not fFlagAXRemoveLegacyTileLatencyStats and {
			Page = data.currentPageName,
			OpaquePage = data.opaquePageName,
			ColdStart = data.coldStart,
			Category = data.currentCategory,
			Subcategory = data.currentSubcategory
		} or nil

		local v9 = {
			page = data.currentPageName,
			opaquePage = data.opaquePageName,
			coldStart = data.coldStart,
			category = data.currentCategory,
			subcategory = data.currentSubcategory
		}

		if p3 then
			if p2 then
				widgetsPercievedTTIManager.L2.surfaceReady()
			else
				widgetsPercievedTTIManager.L2.functionallyReady()
			end
		end

		if not p3 then
			if p2 then
				organicTTIMilestoneManager.L2.surfaceReady()
			else
				organicTTIMilestoneManager.L2.functionallyReady()
			end
		end

		local root = ttiPerformanceManager.Surface.Marketplace.Root
		root.endTracking(v7, v9)

		if v6 then
			root.endPerceivedTracking(v7, v9)
		end

		if not fFlagAXRemoveLegacyTileLatencyStats then
			sendAXStat({ statName = v7, deltaMs = v5, metaData = v8 })
		end

		if v6 and not fFlagAXRemoveLegacyTileLatencyStats then
			sendAXStat({
				statName = v7 .. "_Percieved",
				deltaMs = v6,
				metaData = v8
			})
		end

		if MemStorageService:GetItem(module6.MemStorageKeys.ColdStart.CatalogAndCatalogSearch) and p2 then
			MemStorageService:SetItem(module6.MemStorageKeys.ColdStart.CatalogAndCatalogSearch, "false")
		end
	end
end

local function perceivedStartTimeSelector(p2)
	return p2.AvatarExperience.Catalog.ResultsList.perceivedStartTime or nil
end

local function useTileLoadingLatencyInitializer(p2)
	local v5 = useAvatarRoute()
	local name = v5.current.name
	local name2 = if v5.opaque then v5.opaque.name else nil
	local v6 = useDispatch()
	local v7 = module2(module)
	local v8 = module4()
	local v9 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.ResultsList[p2]
			and p3.AvatarExperience.Catalog.ResultsList[p2].tileLoadingLatency
			and p3.AvatarExperience.Catalog.ResultsList[p2].tileLoadingLatency.thumbnails
			or nil
	end, getUseSelectorDeepEquals())
	local v10 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.ResultsList[p2]
			and p3.AvatarExperience.Catalog.ResultsList[p2].tileLoadingLatency
			and p3.AvatarExperience.Catalog.ResultsList[p2].tileLoadingLatency.startTime
			or nil
	end, getUseSelectorDeepEquals())
	local v11 = useSelector(perceivedStartTimeSelector, getUseSelectorDeepEquals())
	local v12 = useSelector(function(p3)
		return p3.AvatarExperience.Catalog.ResultsList[p2]
			and p3.AvatarExperience.Catalog.ResultsList[p2].tileLoadingLatency
			and p3.AvatarExperience.Catalog.ResultsList[p2].tileLoadingLatency.endTime
			or nil
	end, getUseSelectorDeepEquals())
	local v13 = MemStorageService:GetItem(module6.MemStorageKeys.ColdStart.CatalogAndCatalogSearch) ~= "false"

	local v14 = usePrevious(v9)
	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")

	React.useEffect(function()
		if not v8 then
			return
		end

		if name == avatarScreen.CatalogSearch then
			setState(v8.catalogSearchCategory)
			setState2(v8.catalogSearchSubcategory)
		else
			setState(v8.catalogCategory)
			setState2(v8.catalogSubcategory)
		end
	end, { name, v8 })

	return {
		dispatch = v6,
		analytics = v7,
		trackerLoadedThumbnails = v9,
		trackerStartTime = v10,
		trackerEndTime = v12,
		coldStart = v13,
		prevImpressionResults = v14,
		currentCategory = state,
		setCurrentCategory = setState,
		currentSubcategory = state2,
		setCurrentSubcategory = setState2,
		currentPageName = name,
		searchUuid = p2,
		opaquePageName = name2,
		fireTileLoadingLatencyTracker = fireTileLoadingLatencyTracker,
		trackerPerceivedStartTime = v11
	}
end

return useTileLoadingLatencyInitializer
