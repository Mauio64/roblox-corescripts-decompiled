local module = require("@luauforge/bundled/dTk")
local module2 = require("@luauforge/bundled/dTx")
local module3 = require("@luauforge/bundled/dTo")
local module4 = require("@luauforge/bundled/dTl")
local module5 = require("@luauforge/bundled/dUJ")

local fFlagSduiMarketplaceCatalogCategorySupport = module3.FFlagSduiMarketplaceCatalogCategorySupport

local function useMarketplaceCatalogCategoryMenuEnabledButtonIds(value, value2)
	local v5 = value or ""
	local v6 = value2 or ""

	local v7 = module.useMemo(function()
		if not fFlagSduiMarketplaceCatalogCategorySupport or v5 == "" and v6 == "" then
			return module4.createComputed(function(): nil
				return nil
			end)
		end

		local marketplaceCatalogCategoryStore = module2.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false)

		local function readButtonsEnabled(p2, p3)
			if p3 == "" then
				return nil
			end

			local marketplaceCatalogCategory = marketplaceCatalogCategoryStore.getMarketplaceCatalogCategory(p3)

			if marketplaceCatalogCategory.status(p2) ~= module2.DataStatus.Ready then
				return nil
			end

			local data = marketplaceCatalogCategory.data(p2)
			local buttonsEnabled = if data then data.buttonsEnabled else nil

			if buttonsEnabled and #buttonsEnabled ~= 0 then
				return buttonsEnabled
			end

			return nil
		end

		return module4.createComputed(function(p2)
			return readButtonsEnabled(p2, v6) or readButtonsEnabled(p2, v5)
		end)
	end, { v5, v6 })

	return module5.useSignalState(v7)
end

return useMarketplaceCatalogCategoryMenuEnabledButtonIds
