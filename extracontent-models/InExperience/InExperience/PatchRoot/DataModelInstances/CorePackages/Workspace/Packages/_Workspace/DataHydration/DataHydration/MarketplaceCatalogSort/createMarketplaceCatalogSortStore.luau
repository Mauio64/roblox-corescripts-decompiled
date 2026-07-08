local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local Signals = require(DataHydrationParent.Signals)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceCatalogSortStoreTypes)

local FFlagMarketplaceCatalogSortTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogSortTrackLastReceived

local function createMarketplaceCatalogSortStore() -- line: 22
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), FFlagMarketplaceCatalogSortTrackLastReceived (copy), Signals (copy)
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

	if FFlagMarketplaceCatalogSortTrackLastReceived then
		local v14

		v12, v14 = Signals.createSignal({})
		u13 = v14
	end

	local function updateMarketplaceCatalogSorts(t2: {[any]: any}) -- line: 41
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
		getMarketplaceCatalogSort = v11.getCachedItem,
		getMarketplaceCatalogSorts = v11.getCachedItems,
		updateMarketplaceCatalogSorts = if not FFlagMarketplaceCatalogSortTrackLastReceived then v10.updateItems else updateMarketplaceCatalogSorts,
		updateMarketplaceCatalogSort = v10.updateItem,
		getLastReceivedSorts = v12,
		clear = if not FFlagMarketplaceCatalogSortTrackLastReceived then v11.clear else clear,
		dispose = v11.dispose
	}
end

return createMarketplaceCatalogSortStore
