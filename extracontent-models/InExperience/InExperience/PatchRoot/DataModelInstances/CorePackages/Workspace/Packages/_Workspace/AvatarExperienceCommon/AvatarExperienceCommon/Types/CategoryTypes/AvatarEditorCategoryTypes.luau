local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

require(AvatarExperienceCommon.Enums.CatalogSubcategories)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local CatalogCategories = AvatarExperienceModel.Enums.CatalogCategories

require(script.Parent.CategoryTypes)

return {}
