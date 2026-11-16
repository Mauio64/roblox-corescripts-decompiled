local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local v5 = {
	categoryId = require("@luauforge/bundled/dMx").DefaultCatalogCategoryId,
	subcategoryId = nil
}

return Rodux.createReducer(v5, {})
