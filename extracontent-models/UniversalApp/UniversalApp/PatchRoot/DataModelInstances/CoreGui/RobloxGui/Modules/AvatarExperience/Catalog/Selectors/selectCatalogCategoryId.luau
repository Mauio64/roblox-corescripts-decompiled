local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function selectCatalogCategoryId(p1) -- line: 6
	return p1.AvatarExperience.Catalog.Categories.categoryId
end

return selectCatalogCategoryId
