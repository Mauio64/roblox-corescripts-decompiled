local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)

local rawValue = AvatarExperienceModel.Enums.CatalogCategories.Recommended:rawValue()

local function getShouldPageUseWidgetOnlyFetcher(p, p2: number?, p3: string?): boolean
	return not not p and not p3 and p.Id == rawValue and not (p2 and p2 > 0)
end

return getShouldPageUseWidgetOnlyFetcher
