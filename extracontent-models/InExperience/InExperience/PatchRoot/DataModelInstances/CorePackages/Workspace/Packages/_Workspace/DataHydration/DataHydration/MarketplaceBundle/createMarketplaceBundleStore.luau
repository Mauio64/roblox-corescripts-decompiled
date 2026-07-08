local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceBundleStoreTypes)

local createDataResolver = require(DataHydration.createDataResolver)

local function createMarketplaceBundleStore() -- line: 10
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy)
	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		fetchFn = function(_: {[any]: any}) -- line: 15
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})

	return {
		getMarketplaceBundleInfo = v8.getCachedItem,
		getMarketplaceBundleInfos = v8.getCachedItems,
		updateMarketplaceBundleInfo = v7.updateItem,
		updateMarketplaceBundleInfos = v7.updateItems,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createMarketplaceBundleStore
