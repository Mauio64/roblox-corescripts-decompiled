local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

return function() -- line: 7
	-- upvalues: GetCatalogCategoriesStore (copy)
	return GetCatalogCategoriesStore.getCatalogCategoriesStore().getCategoriesMap(false) or {}
end
