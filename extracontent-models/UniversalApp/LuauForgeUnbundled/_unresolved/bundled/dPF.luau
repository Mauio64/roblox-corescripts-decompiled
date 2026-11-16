require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fFlagAXMigrateAllTabToSduiDev = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateAllTabToSduiDev

local module = require("@luauforge/bundled/dPG")

return function()
	local catalogCategoriesStore = module.getCatalogCategoriesStore()

	if fFlagAXMigrateAllTabToSduiDev then
		return catalogCategoriesStore.getCategoriesMap(false)
	end

	return catalogCategoriesStore.getCategories(false)
end
