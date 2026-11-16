require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local rawValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.CatalogCategories.Recommended:rawValue()

local function getShouldPageUseWidgetOnlyFetcher(p2, p3, p4): boolean
	if not p2 or p4 or p2.Id ~= rawValue or p3 and p3 > 0 then
		return false
	end

	return true
end

return getShouldPageUseWidgetOnlyFetcher
