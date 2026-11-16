local module = require("@luauforge/bundled/dQh")

return {
	resolveDefaultLeafId = function(p2)
		local marketplaceCatalogCategory = module.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(p2)
		local v5

		if marketplaceCatalogCategory and marketplaceCatalogCategory.data then
			v5 = marketplaceCatalogCategory.data(false)
		end

		local defaultSubcategoryId = if v5 then v5.defaultSubcategoryId else nil

		if typeof(defaultSubcategoryId) == "string" and defaultSubcategoryId ~= "" then
			return defaultSubcategoryId
		end

		return p2
	end
}
