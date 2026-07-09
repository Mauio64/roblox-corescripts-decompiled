local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local DefaultFilters = require(Modules.AvatarExperience.Catalog.CatalogConstants).DefaultFilters

local function selectFilterCount(p1) -- line: 8
	-- upvalues: DefaultFilters (copy)
	local SortAndFilters = p1.AvatarExperience.Catalog.SortAndFilters
	local n1 = 0

	if SortAndFilters.PriceRange.minPrice ~= DefaultFilters.PriceRange.minPrice or SortAndFilters.PriceRange.maxPrice ~= DefaultFilters.PriceRange.maxPrice then
		n1 += 1
	end

	if SortAndFilters.SalesTypeFilter ~= DefaultFilters.SalesTypeFilter then
		n1 += 1
	end

	if SortAndFilters.CreatorFilter ~= DefaultFilters.CreatorFilter then
		n1 += 1
	end

	if SortAndFilters.UnavailableItemFilter ~= DefaultFilters.UnavailableItemFilter then
		n1 += 1
	end

	if SortAndFilters.CatalogSort ~= DefaultFilters.CatalogSort then
		n1 += 1
	end

	return n1
end

return selectFilterCount
