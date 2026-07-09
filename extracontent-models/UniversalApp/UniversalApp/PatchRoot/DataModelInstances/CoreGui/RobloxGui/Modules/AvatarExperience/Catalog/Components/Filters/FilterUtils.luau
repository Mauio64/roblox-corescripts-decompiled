local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)

local SortType = require(Modules.AvatarExperience.Common.Enum.SortType)

require(Modules.AvatarExperience.Common.Enum.SortAggregation)
require(Modules.AvatarExperience.Catalog.Reducers.SortAndFilters)

local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(Modules.AvatarExperience.Common.Types)

local t1 = {
	mapHeightToSize = function(n1: number) -- line: 18
		return UDim2.new(1, 0, 0, n1)
	end,
	selectCatalogSort = function(p1) -- line: 22
		return p1.AvatarExperience.Catalog.SortAndFilters.CatalogSort
	end,
	selectCatalogSortAggregation = function(p2) -- line: 26
		return p2.AvatarExperience.Catalog.SortAndFilters.CatalogSortAggregation
	end,
	selectSalesTypeFilter = function(p3) -- line: 30
		return p3.AvatarExperience.Catalog.SortAndFilters.SalesTypeFilter
	end,
	selectCreatorFilter = function(p4) -- line: 34
		return p4.AvatarExperience.Catalog.SortAndFilters.CreatorFilter
	end,
	selectWearTimeFilter = function(p5) -- line: 38
		return p5.AvatarExperience.Catalog.SortAndFilters.WearTimeFilter
	end,
	selectUnavailableItemFilter = function(p6) -- line: 42
		return p6.AvatarExperience.Catalog.SortAndFilters.UnavailableItemFilter
	end,
	selectMinPrice = function(p7) -- line: 46
		return p7.AvatarExperience.Catalog.SortAndFilters.PriceRange.minPrice
	end,
	selectMaxPrice = function(p8) -- line: 50
		return p8.AvatarExperience.Catalog.SortAndFilters.PriceRange.maxPrice
	end,
	selectSortAndFilters = function(p9) -- line: 54
		return p9.AvatarExperience.Catalog.SortAndFilters
	end
}
local v6 = memoize(function(p10, p11, p12, p13, s1: string, p14, t2: {[any]: any}, p15) -- line: 59
	-- upvalues: SortType (copy)
	return p10 .. "," .. (not (p10 == SortType.MostFavorited or p10 == SortType.Bestselling) and "" or p11) .. "," .. p12.minPrice .. "," .. p12.maxPrice .. "," .. p13 .. "," .. s1 .. "," .. p14 .. "," .. table.concat(t2, "-") .. "," .. (p15 or "")
end)

function t1.selectSortAndFiltersKey(p16) -- line: 92
	-- upvalues: t1 (copy)
	local SortAndFilters = p16.AvatarExperience.Catalog.SortAndFilters

	return t1.buildSortAndFiltersKeyFromSortAndFilters(SortAndFilters)
end
function t1.buildSortAndFiltersKeyFromSortAndFilters(p17) -- line: 98
	-- upvalues: v6 (copy)
	local CatalogSort = p17.CatalogSort
	local CatalogSortAggregation = p17.CatalogSortAggregation
	local PriceRange = p17.PriceRange
	local SalesTypeFilter = p17.SalesTypeFilter
	local CreatorFilter = p17.CreatorFilter
	local UnavailableItemFilter = p17.UnavailableItemFilter
	local SelectedTopics = p17.SelectedTopics
	local WearTimeFilter = p17.WearTimeFilter

	return v6(CatalogSort, CatalogSortAggregation, PriceRange, SalesTypeFilter, CreatorFilter, UnavailableItemFilter, SelectedTopics, WearTimeFilter)
end
function t1.areSortAndFiltersEqual(p18, p19) -- line: 119
	-- upvalues: t1 (copy)
	return t1.buildSortAndFiltersKeyFromSortAndFilters(p18) == t1.buildSortAndFiltersKeyFromSortAndFilters(p19)
end

return t1
