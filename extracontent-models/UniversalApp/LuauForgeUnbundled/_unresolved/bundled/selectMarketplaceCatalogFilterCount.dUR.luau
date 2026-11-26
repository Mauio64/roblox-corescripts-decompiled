local fFlagAXCatalogSpecialFeaturesFilter = require("@luauforge/bundled/dTp").FFlagAXCatalogSpecialFeaturesFilter

local v5 = {
	minPrice = 0,
	maxPrice = 2147483647,
	salesTypeFilter = "All",
	creatorFilter = "",
	unavailableItemFilter = "Hide",
	catalogSort = "Relevance"
}

local function selectMarketplaceCatalogFilterCount(p2)
	local catalog = p2 and p2.AvatarExperience and p2.AvatarExperience.Catalog
	local sortAndFilters = catalog and catalog.SortAndFilters

	if not sortAndFilters then
		return 0
	end

	local count = 0
	local priceRange = sortAndFilters.PriceRange

	if priceRange and (priceRange.minPrice ~= 0 or priceRange.maxPrice ~= 2147483647) then
		count += 1
	end

	if sortAndFilters.SalesTypeFilter ~= "All" then
		count += 1
	end

	if sortAndFilters.CreatorFilter ~= "" then
		count += 1
	end

	if sortAndFilters.UnavailableItemFilter ~= "Hide" then
		count += 1
	end

	if sortAndFilters.CatalogSort ~= "Relevance" then
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

return selectMarketplaceCatalogFilterCount
