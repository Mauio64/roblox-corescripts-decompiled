local module = require("@luauforge/bundled/dPG")

return function()
	return module.getCatalogCategoriesStore().getCategoriesMap(false) or {}
end
