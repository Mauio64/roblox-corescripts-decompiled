local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceCatalogCategoryStoreTypes)

local FFlagMarketplaceCatalogCategoryTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogCategoryTrackLastReceived
local FFlagSduiSkipEmptyCatalogCategoryHydration = SharedFlags.FFlagSduiSkipEmptyCatalogCategoryHydration

local function createMarketplaceCatalogCategoryStore()
	local getLastReceivedCategories, v

	if FFlagMarketplaceCatalogCategoryTrackLastReceived then
		getLastReceivedCategories, v = Signals.createSignal({})
	else
		v = nil
	end

	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end,
		onClear = FFlagSduiSkipEmptyCatalogCategoryHydration and function()
			if v then
				v({})
			end
		end or nil
	})

	local function updateMarketplaceCatalogCategories(items)
		if FFlagSduiSkipEmptyCatalogCategoryHydration and next(items) == nil then
			return
		end

		v(items)
		dataCache.updateItems(items)
	end

	local function clear()
		if v then
			v({})
		end

		dataResolver.clear()
	end

	local marketplaceCatalogCategoryStore = {
		getMarketplaceCatalogCategory = dataResolver.getCachedItem,
		getMarketplaceCatalogCategories = dataResolver.getCachedItems,
		updateMarketplaceCatalogCategories = 0,
		updateMarketplaceCatalogCategory = 0,
		getLastReceivedCategories = 0,
		clear = 0,
		dispose = 0
	}

	if not FFlagMarketplaceCatalogCategoryTrackLastReceived then
		updateMarketplaceCatalogCategories = dataCache.updateItems
	end

	marketplaceCatalogCategoryStore.updateMarketplaceCatalogCategories = updateMarketplaceCatalogCategories

	marketplaceCatalogCategoryStore.updateMarketplaceCatalogCategory = dataCache.updateItem
	marketplaceCatalogCategoryStore.getLastReceivedCategories = getLastReceivedCategories

	if not FFlagMarketplaceCatalogCategoryTrackLastReceived then
		clear = dataResolver.clear
	end

	marketplaceCatalogCategoryStore.clear = clear
	marketplaceCatalogCategoryStore.dispose = dataResolver.dispose
	return marketplaceCatalogCategoryStore
end

return createMarketplaceCatalogCategoryStore
