local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceCatalogCategory/MarketplaceCatalogCategoryStoreTypes")

local fFlagMarketplaceCatalogCategoryTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogCategoryTrackLastReceived
local fFlagSduiSkipEmptyCatalogCategoryHydration = SharedFlags.FFlagSduiSkipEmptyCatalogCategoryHydration

local function createMarketplaceCatalogCategoryStore()
	local v5, v6

	if fFlagMarketplaceCatalogCategoryTrackLastReceived then
		v5, v6 = Signals.createSignal({})
	else
		v6 = nil
	end

	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		fetchFn = function(p2)
			return Promise.resolve({})
		end,
		onClear = fFlagSduiSkipEmptyCatalogCategoryHydration and function()
			if v6 then
				v6({})
			end
		end or nil
	})

	local function updateMarketplaceCatalogCategories(items)
		if fFlagSduiSkipEmptyCatalogCategoryHydration and next(items) == nil then
			return
		end

		v6(items)
		v7.updateItems(items)
	end

	local function clear()
		if v6 then
			v6({})
		end

		v8.clear()
	end

	local marketplaceCatalogCategoryStore = {
		getMarketplaceCatalogCategory = v8.getCachedItem,
		getMarketplaceCatalogCategories = v8.getCachedItems,
		updateMarketplaceCatalogCategories = 0,
		updateMarketplaceCatalogCategory = 0,
		getLastReceivedCategories = 0,
		clear = 0,
		dispose = 0
	}

	if not fFlagMarketplaceCatalogCategoryTrackLastReceived then
		updateMarketplaceCatalogCategories = v7.updateItems
	end

	marketplaceCatalogCategoryStore.updateMarketplaceCatalogCategories = updateMarketplaceCatalogCategories

	marketplaceCatalogCategoryStore.updateMarketplaceCatalogCategory = v7.updateItem
	marketplaceCatalogCategoryStore.getLastReceivedCategories = v5

	if not fFlagMarketplaceCatalogCategoryTrackLastReceived then
		clear = v8.clear
	end

	marketplaceCatalogCategoryStore.clear = clear
	marketplaceCatalogCategoryStore.dispose = v8.dispose
	return marketplaceCatalogCategoryStore
end

return createMarketplaceCatalogCategoryStore
