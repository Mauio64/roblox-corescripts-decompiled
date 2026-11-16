require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/CatalogV2SearchItemDetails")

local function addSpecialFeaturesFilter(p2, requiredPropertyFilters)
	if requiredPropertyFilters == nil or #requiredPropertyFilters == 0 then
		return p2
	end

	local clone = table.clone(p2)
	clone.requiredPropertyFilters = requiredPropertyFilters
	return clone
end

return addSpecialFeaturesFilter
