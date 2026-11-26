local module = require("@luauforge/bundled/dSW")

return function()
	return module.getCatalogCategoriesStore().getCategoriesMap(false) or {}
end
