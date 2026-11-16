local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/dQh")
local module3 = require("@luauforge/bundled/dPY")
local module4 = require("@luauforge/bundled/dPV")
local module5 = require("@luauforge/bundled/dRp")

local fFlagSduiMarketplaceCatalogCategorySupport = module3.FFlagSduiMarketplaceCatalogCategorySupport

local function useMarketplaceCatalogCategoryMenuDefaultSubcategoryId(value)
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

			if data then
				return data.defaultSubcategoryId
			end

			return nil
		end)
	end, { v5 })

	return module5.useSignalState(v6)
end

return useMarketplaceCatalogCategoryMenuDefaultSubcategoryId
