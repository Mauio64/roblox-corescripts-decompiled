require("@luauforge/bundled/dKT")

require("@luauforge/bundled/dPF")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dPE")
local module = require("@luauforge/bundled/dPG")
require("@luauforge/bundled/dPH")
require("@luauforge/bundled/dVO")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
require("@luauforge/bundled/dPs")

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local v5 = {
	mapHeightToSize = function(p2)
		return UDim2.new(1, 0, 0, p2)
	end,
	selectCatalogSort = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.CatalogSort
	end,
	selectCatalogSortAggregation = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.CatalogSortAggregation
	end,
	selectSalesTypeFilter = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.SalesTypeFilter
	end,
	selectCreatorFilter = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.CreatorFilter
	end,
	selectWearTimeFilter = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.WearTimeFilter
	end,
	selectSpecialFeaturesFilter = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.SpecialFeaturesFilter
	end,
	selectUnavailableItemFilter = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.UnavailableItemFilter
	end,
	selectMinPrice = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.PriceRange.minPrice
	end,
	selectMaxPrice = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters.PriceRange.maxPrice
	end,
	selectSortAndFilters = function(p2)
		return p2.AvatarExperience.Catalog.SortAndFilters
	end
}

local v6 = memoize(function(p2, p3, p4, p5, p6, p7, list, value)
	return p2 .. "," .. (p2 ~= module.MostFavorited and p2 ~= module.Bestselling and "" or p3) .. "," .. p4.minPrice .. "," .. p4.maxPrice .. "," .. p5 .. "," .. p6 .. "," .. p7 .. "," .. table.concat(list, "-") .. "," .. (value or "")
end)

function v5.selectSortAndFiltersKey(p2)
	local sortAndFilters = p2.AvatarExperience.Catalog.SortAndFilters

	return v5.buildSortAndFiltersKeyFromSortAndFilters(sortAndFilters)
end

function v5.buildSortAndFiltersKeyFromSortAndFilters(data)
	local sortAndFiltersKeyFromSortAndFilters = v6(
		data.CatalogSort,
		data.CatalogSortAggregation,
		data.PriceRange,
		data.SalesTypeFilter,
		data.CreatorFilter,
		data.UnavailableItemFilter,
		data.SelectedTopics,
		data.WearTimeFilter
	)

	if fFlagAXCatalogSpecialFeaturesFilter then
		sortAndFiltersKeyFromSortAndFilters ..= "," .. table.concat(data.SpecialFeaturesFilter or {}, "-")
	end

	return sortAndFiltersKeyFromSortAndFilters
end

function v5.areSortAndFiltersEqual(p2, p3): boolean
	return v5.buildSortAndFiltersKeyFromSortAndFilters(p2) == v5.buildSortAndFiltersKeyFromSortAndFilters(p3)
end

return v5
