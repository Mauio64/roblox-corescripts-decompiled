local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local FFlagAXMigrateAllTabToSduiDev = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMigrateAllTabToSduiDev
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

return function() -- line: 22
	-- upvalues: GetCatalogCategoriesStore (copy), FFlagAXMigrateAllTabToSduiDev (copy)
	local v6 = GetCatalogCategoriesStore.getCatalogCategoriesStore()

	if FFlagAXMigrateAllTabToSduiDev then
		return v6.getCategoriesMap(false)
	end

	return v6.getCategories(false)
end
