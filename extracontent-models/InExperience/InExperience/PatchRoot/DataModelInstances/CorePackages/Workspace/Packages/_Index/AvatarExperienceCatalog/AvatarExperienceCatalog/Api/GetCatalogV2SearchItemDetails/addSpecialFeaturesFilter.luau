local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)

local function addSpecialFeaturesFilter(p, requiredPropertyFilters)
	if requiredPropertyFilters == nil or #requiredPropertyFilters == 0 then
		return p
	end

	local clone = table.clone(p)
	clone.requiredPropertyFilters = requiredPropertyFilters
	return clone
end

return addSpecialFeaturesFilter
