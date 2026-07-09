local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local PillGroup = require(CorePackages.Packages.UIBlox).App.Control.PillGroup
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local useCatalogTopics = require(Modules.AvatarExperience.Catalog.Hooks.useCatalogTopics)
local useSelectedTopics = require(Modules.AvatarExperience.Catalog.Hooks.useSelectedTopics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local FilterButtonLayout = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButtonLayout)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local useSearchParameters = require(Modules.AvatarExperience.Catalog.Hooks.useSearchParameters)
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local v20 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.topics")
local v21 = game:DefineFastInt("AXTopicsNumInitialItems", 10)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXCatalogSearchSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSearchSupportDisableFilters
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

local function findRemovedTopic(t1: {[any]: any}, t2: {[any]: any}) -- line: 55
	-- upvalues: Cryo (copy)
	for _, v32 in t1 do
		if not Cryo.List.find(t2, v32) then
			return v32
		end
	end

	return nil
end

local v27 = memoize(function(t3: {[any]: any}) -- line: 70
	-- upvalues: Cryo (copy), v21 (copy)
	return Cryo.List.filterMap(t3, function(p1, p2) -- line: 71
		-- upvalues: v21 (copy)
		if p2 > v21 then
			return nil
		end

		return {
			targetId = tonumber(p1.id) or 0,
			itemType = p1.type
		}
	end)
end)

local function CatalogTopicBar(t4: {[any]: any}) -- line: 82
	-- upvalues: v27 (copy), useSelectedTopics (copy), useCatalogTopics (copy), useRoactService (copy), Analytics (copy), Analytics2 (copy), React (copy), GetCatalogCategoriesStore (copy), Cryo (copy), findRemovedTopic (copy), v20 (copy), useDispatch (copy), useNavigation (copy), useSearchParameters (copy), NavigateToSearch (copy), Exit3DFullView (copy), FilterButtonLayout (copy), Constants (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), FFlagAXCatalogSearchSupportDisableFilters (copy), PillGroup (copy)
	local v35 = v27(t4.items or {})
	local searchKeyword = t4.searchKeyword
	local v37, v38 = useSelectedTopics()
	local v39, v40 = useCatalogTopics(v37, v35, searchKeyword)
	local v41 = useRoactService(Analytics)
	local v42 = useRoactService(Analytics2)
	local v43 = React.useCallback(function(t5: {[any]: any}) -- line: 90
		-- upvalues: v39 (copy), v37 (copy), GetCatalogCategoriesStore (copy), Cryo (copy), v41 (copy), findRemovedTopic (copy), v20 (copy)
		local v51 = v39
		local v52 = v37
		local v53 = GetCatalogCategoriesStore.getCatalogSelectionStore()
		local v54 = v53.selectedCategoryId(false)
		local v55 = v53.selectedSubcategoryId(false)

		if #t5 > #v37 then
			local v56 = t5[#t5]
			local v57 = Cryo.List.find(v39, v56) or 0

			v41.selectTopic(v56, v57, v54, v55, nil, v51, v52)

			return
		end

		if #t5 == #v37 - 1 then
			if not findRemovedTopic(v37, t5) then
				v20:warning("sendTopicsChangedAnalyticsEvent, removedTopic not found: {} -> {}", v37, t5)

				return
			end
		else
			v20:warning("sendTopicsChangedAnalyticsEvent, invalid change: {} -> {}", v37, t5)
		end
	end, {
		v37,
		v39,
		findRemovedTopic
	})
	local v44 = useDispatch()
	local v45 = useNavigation()
	local u46 = useSearchParameters()
	local v47 = React.useCallback(function(t6: {[any]: any}) -- line: 132
		-- upvalues: v43 (copy), t4 (copy), u46 (ref), v38 (copy), v44 (copy), NavigateToSearch (copy), v45 (copy), Exit3DFullView (copy), v42 (copy)
		v43(t6)

		if t4.searchKeyword then
			u46 = u46 or {}
			assert(u46, "")
			v38(t6)
			v44(NavigateToSearch(v45, u46))
		else
			v38(t6)
		end

		v44(Exit3DFullView(v42, v45.state.routeName))
	end, {
		v43,
		t4.searchKeyword,
		u46,
		v44,
		v45,
		v42
	})

	return React.createElement(FilterButtonLayout, {
		height = Constants.PillBarHeight,
		layoutOrder = t4.layoutOrder,
		showFilterButton = not FFlagAXMoveCatalogFilterToL1Navigation and (not FFlagAXCatalogSearchSupportDisableFilters or (t4.showFilterButton == nil or t4.showFilterButton)),
		layoutRef = t4.frameRef,
		NextSelectionUp = t4.NextSelectionUp,
		NextSelectionDown = t4.NextSelectionDown
	}, {
		Topics = React.createElement(PillGroup, {
			layoutOrder = 2,
			leftPadding = 0,
			pills = v39,
			selectedPills = v37,
			isLoading = v40,
			onSelectionChanged = v47
		})
	})
end

return (React.memo(CatalogTopicBar))
