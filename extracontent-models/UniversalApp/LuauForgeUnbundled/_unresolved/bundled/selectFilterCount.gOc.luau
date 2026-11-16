require("@luauforge/bundled/dHK")

local defaultFilters = require("@luauforge/bundled/dME").DefaultFilters

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local function selectFilterCount(p2)
	local sortAndFilters = p2.AvatarExperience.Catalog.SortAndFilters
	local count = 0

	if
		sortAndFilters.PriceRange.minPrice ~= defaultFilters.PriceRange.minPrice
		or sortAndFilters.PriceRange.maxPrice ~= defaultFilters.PriceRange.maxPrice
	then
		count += 1
	end

	if sortAndFilters.SalesTypeFilter ~= defaultFilters.SalesTypeFilter then
		count += 1
	end

	if sortAndFilters.CreatorFilter ~= defaultFilters.CreatorFilter then
		count += 1
	end

	if sortAndFilters.UnavailableItemFilter ~= defaultFilters.UnavailableItemFilter then
		count += 1
	end

	if sortAndFilters.CatalogSort ~= defaultFilters.CatalogSort then
		count += 1
	end

	if
		fFlagAXCatalogSpecialFeaturesFilter
		and sortAndFilters.SpecialFeaturesFilter
		and #sortAndFilters.SpecialFeaturesFilter > 0
	then
		count += 1
	end

	return count
end

return selectFilterCount
