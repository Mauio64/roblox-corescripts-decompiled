local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local SortType = require(Modules.AvatarExperience.Common.Enum.SortType)
local SortAggregation = require(Modules.AvatarExperience.Common.Enum.SortAggregation)
local SetCatalogSort = require(Modules.AvatarExperience.Catalog.Actions.SetCatalogSort)
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function useSortsController() -- line: 52
	-- upvalues: useRoactService (copy), Analytics (copy), useSelector (copy), FilterUtils (copy), getUseSelectorDeepEquals (copy), React (copy), useDispatch (copy), SortType (copy), SortAggregation (copy), SetCatalogSort (copy)
	useRoactService(Analytics)

	local v14 = useSelector(FilterUtils.selectCatalogSort, getUseSelectorDeepEquals())
	local v15 = useSelector(FilterUtils.selectCatalogSortAggregation, getUseSelectorDeepEquals())
	local v16, v17 = React.useState(v14)
	local v18, v19 = React.useState(v15)
	local v20, v21 = React.useState(v15)
	local v22 = useDispatch()
	local v23 = v16 ~= SortType.Relevance
	local v24 = v16 ~= v14 or (v16 == SortType.MostFavorited and v18 ~= v15 or v16 == SortType.Bestselling and v20 ~= v15)
	local v25 = React.useCallback(function() -- line: 72
		-- upvalues: v17 (copy), SortType (copy), v19 (copy), SortAggregation (copy), v21 (copy)
		v17(SortType.Relevance)
		v19(SortAggregation.AllTime)
		v21(SortAggregation.AllTime)
	end)
	local v26 = React.useCallback(function() -- line: 78
		-- upvalues: SortAggregation (copy), v16 (copy), SortType (copy), v18 (copy), v20 (copy), v22 (copy), SetCatalogSort (copy)
		local AllTime = SortAggregation.AllTime

		if v16 == SortType.MostFavorited then
			AllTime = v18
		elseif v16 == SortType.Bestselling then
			AllTime = v20
		end

		v22(SetCatalogSort(v16, AllTime))
	end, {
		v16,
		v18,
		v20
	})

	return {
		sortType = v16,
		setSortType = v17,
		mostFavoritedAggregation = v18,
		setMostFavoritedAggregation = v19,
		bestSellingAggregation = v20,
		setBestSellingAggregation = v21,
		canReset = v23,
		canApply = v24,
		reset = v25,
		apply = v26
	}
end

return useSortsController
