local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function selectCatalogSubcategoryId(p1) -- line: 6
	return p1.AvatarExperience.Catalog.Categories.subcategoryId
end

return selectCatalogSubcategoryId
