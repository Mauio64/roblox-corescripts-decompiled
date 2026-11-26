local module = require("@luauforge/bundled/dTk")
require("@luauforge/bundled/dUK")
local module2 = require("@luauforge/bundled/dTx")
local module3 = require("@luauforge/bundled/dTo")
local module4 = require("@luauforge/bundled/dTl")
local module5 = require("@luauforge/bundled/dUJ")

local fFlagSduiMarketplaceCatalogCategorySupport = module3.FFlagSduiMarketplaceCatalogCategorySupport

local function useMarketplaceCatalogCategoryMenuSubcategories(value)
	local v5 = value or ""

	local v6 = module.useMemo(function()
		if not fFlagSduiMarketplaceCatalogCategorySupport or v5 == "" then
			return module4.createComputed(function(): nil
				return nil
			end)
		end

		local marketplaceCatalogCategoryStore = module2.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false)

		return module4.createComputed(function(p2)
			local marketplaceCatalogCategory = marketplaceCatalogCategoryStore.getMarketplaceCatalogCategory(v5)

			if marketplaceCatalogCategory.status(p2) ~= module2.DataStatus.Ready then
				return nil
			end

			local data = marketplaceCatalogCategory.data(p2)

			if not data then
				return nil
			end

			local subcategories = data.subcategories

			if not subcategories or #subcategories == 0 then
				return nil
			end

			local result = {}

			for k, subcategory in subcategories do
				local marketplaceCatalogCategory2 = marketplaceCatalogCategoryStore.getMarketplaceCatalogCategory(subcategory)

				if marketplaceCatalogCategory2.status(p2) ~= module2.DataStatus.Ready then
					continue
				end

				local data2 = marketplaceCatalogCategory2.data(p2)

				if data2 then
					table.insert(result, { id = data2.id, text = data2.title })
				end
			end

			if #result == 0 then
				return nil
			end

			return result
		end)
	end, { v5 })

	return module5.useSignalState(v6)
end

return useMarketplaceCatalogCategoryMenuSubcategories
