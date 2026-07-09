local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local CreatorFilter = require(Modules.AvatarExperience.Common.Enum.CreatorFilter)
local PriceFilter = require(Modules.AvatarExperience.Common.Enum.PriceFilter)
local SalesTypeFilter = require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
local UnavailableItemFilter = require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local SetSalesTypeFilter = require(Modules.AvatarExperience.Catalog.Actions.SetSalesTypeFilter)
local SetCreatorFilter = require(Modules.AvatarExperience.Catalog.Actions.SetCreatorFilter)
local SetPriceRange = require(Modules.AvatarExperience.Catalog.Actions.SetPriceRange)
local SetUnavailableItemFilter = require(Modules.AvatarExperience.Catalog.Actions.SetUnavailableItemFilter)
local SetWearTimeFilter = require(Modules.AvatarExperience.Catalog.Actions.SetWearTimeFilter)
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local WearTimeFilter = AvatarExperienceCommon.Enums.WearTimeFilter
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local FFlagMinMaxPriceValidation = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagMinMaxPriceValidation

local function getPriceSelection(n1: number, n2: number) -- line: 75
	-- upvalues: CatalogConstants (copy), PriceFilter (copy)
	if n1 > CatalogConstants.MinPriceFilter or n2 < CatalogConstants.MaxPriceFilter then
		return PriceFilter.PriceRange
	end

	return PriceFilter.AnyPrice
end
local function getCreatorSelection(s1: string) -- line: 83
	-- upvalues: CreatorFilter (copy)
	if s1 == nil or s1 == "" then
		return CreatorFilter.AllCreators
	end

	return CreatorFilter.Username
end
local function wearTimeFilterChanged(p1, p2) -- line: 91
	return p1 ~= p2
end
local function useFiltersController() -- line: 96
	-- upvalues: useSelector (copy), FilterUtils (copy), getUseSelectorDeepEquals (copy), React (copy), CreatorFilter (copy), CatalogConstants (copy), PriceFilter (copy), useDispatch (copy), SalesTypeFilter (copy), UnavailableItemFilter (copy), WearTimeFilter (copy), wearTimeFilterChanged (copy), FFlagMinMaxPriceValidation (copy), SetSalesTypeFilter (copy), SetCreatorFilter (copy), SetPriceRange (copy), SetUnavailableItemFilter (copy), SetWearTimeFilter (copy)
	local v30 = useSelector(FilterUtils.selectSalesTypeFilter, getUseSelectorDeepEquals())
	local v31, v32 = React.useState(v30)
	local v33 = useSelector(FilterUtils.selectCreatorFilter, getUseSelectorDeepEquals())
	local v34 = if v33 ~= nil and v33 ~= "" then CreatorFilter.Username else CreatorFilter.AllCreators
	local v35, v36 = React.useState(v34)
	local v37, v38 = React.useState(v33)
	local v39 = useSelector(FilterUtils.selectMinPrice, getUseSelectorDeepEquals())
	local v40 = useSelector(FilterUtils.selectMaxPrice, getUseSelectorDeepEquals())
	local v41 = if not (v39 > CatalogConstants.MinPriceFilter) and not (v40 < CatalogConstants.MaxPriceFilter) then PriceFilter.AnyPrice else PriceFilter.PriceRange
	local v42, v43 = React.useState(v41)
	local v44, v45 = React.useState(v39)
	local v46, v47 = React.useState(v40)
	local v48 = useSelector(FilterUtils.selectUnavailableItemFilter, getUseSelectorDeepEquals())
	local v49, v50 = React.useState(v48)
	local v51 = useSelector(FilterUtils.selectWearTimeFilter, getUseSelectorDeepEquals())
	local v52, v53 = React.useState(v51)
	local v54 = useDispatch()
	local v55 = v31 ~= SalesTypeFilter.All or (v35 ~= CreatorFilter.AllCreators or (v42 ~= PriceFilter.AnyPrice or (v49 ~= UnavailableItemFilter.Hide or v52 ~= WearTimeFilter.All)))
	local v56 = if v35 ~= CreatorFilter.AllCreators then v37 else ""
	local v57 = if v42 ~= PriceFilter.AnyPrice then v44 else CatalogConstants.MinPriceFilter
	local v58 = if v42 ~= PriceFilter.AnyPrice then v46 else CatalogConstants.MaxPriceFilter
	local v59 = v31 ~= v30 or (v56 ~= v33 or (v57 ~= v39 or (v58 ~= v40 or (v49 ~= v48 or wearTimeFilterChanged and v52 ~= v51))))

	if FFlagMinMaxPriceValidation and v58 < v57 then
		v59 = false
	end

	local v60 = React.useCallback(function() -- line: 147
		-- upvalues: v32 (copy), SalesTypeFilter (copy), v36 (copy), CreatorFilter (copy), v43 (copy), PriceFilter (copy), v50 (copy), UnavailableItemFilter (copy), v53 (copy), WearTimeFilter (copy)
		v32(SalesTypeFilter.All)
		v36(CreatorFilter.AllCreators)
		v43(PriceFilter.AnyPrice)
		v50(UnavailableItemFilter.Hide)
		v53(WearTimeFilter.All)
	end)
	local v61 = React.useCallback(function() -- line: 156
		-- upvalues: v54 (copy), SetSalesTypeFilter (copy), v31 (copy), SetCreatorFilter (copy), v56 (copy), SetPriceRange (copy), v57 (copy), v58 (copy), SetUnavailableItemFilter (copy), v49 (copy), SetWearTimeFilter (copy), v52 (copy)
		v54(SetSalesTypeFilter(v31))
		v54(SetCreatorFilter(v56))
		v54(SetPriceRange(v57, v58))
		v54(SetUnavailableItemFilter(v49))
		v54(SetWearTimeFilter(v52))
	end, {
		v31,
		v56,
		v57,
		v58,
		v49,
		v52
	})

	return {
		salesTypeFilter = v31,
		setSalesTypeFilter = v32,
		creatorFilter = v35,
		setCreatorFilter = v36,
		creatorUsername = v37,
		setCreatorUsername = v38,
		priceFilter = v42,
		setPriceFilter = v43,
		minPrice = v44,
		setMinPrice = v45,
		maxPrice = v46,
		setMaxPrice = v47,
		wearTimeFilter = v52,
		setWearTimeFilter = v53,
		unavailableItemFilter = v49,
		setUnavailableItemFilter = v50,
		canReset = v55,
		canApply = v59,
		reset = v60,
		apply = v61
	}
end

return useFiltersController
