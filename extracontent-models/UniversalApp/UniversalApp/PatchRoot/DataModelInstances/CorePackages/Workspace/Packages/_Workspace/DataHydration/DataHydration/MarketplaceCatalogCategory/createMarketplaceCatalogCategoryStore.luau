local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local Signals = require(DataHydrationParent.Signals)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceCatalogCategoryStoreTypes)

local FFlagMarketplaceCatalogCategoryTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogCategoryTrackLastReceived

local function createMarketplaceCatalogCategoryStore() -- line: 22
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), FFlagMarketplaceCatalogCategoryTrackLastReceived (copy), Signals (copy)
	local v10 = createDataCache()
	local v11 = createDataResolver({
		cache = v10,
		fetchFn = function(_: {[any]: any}) -- line: 26
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})
	local v12 = nil
	local u13 = nil

	if FFlagMarketplaceCatalogCategoryTrackLastReceived then
		local v14

		v12, v14 = Signals.createSignal({})
		u13 = v14
	end

	local function updateMarketplaceCatalogCategories(t2: {[any]: any}) -- line: 41
		-- upvalues: u13 (ref), v10 (copy)
		u13(t2)
		v10.updateItems(t2)
	end
	local function clear() -- line: 51
		-- upvalues: u13 (ref), v11 (copy)
		if u13 then
			u13({})
		end

		v11.clear()
	end

	return {
		getMarketplaceCatalogCategory = v11.getCachedItem,
		getMarketplaceCatalogCategories = v11.getCachedItems,
		updateMarketplaceCatalogCategories = if not FFlagMarketplaceCatalogCategoryTrackLastReceived then v10.updateItems else updateMarketplaceCatalogCategories,
		updateMarketplaceCatalogCategory = v10.updateItem,
		getLastReceivedCategories = v12,
		clear = if not FFlagMarketplaceCatalogCategoryTrackLastReceived then v11.clear else clear,
		dispose = v11.dispose
	}
end

return createMarketplaceCatalogCategoryStore
