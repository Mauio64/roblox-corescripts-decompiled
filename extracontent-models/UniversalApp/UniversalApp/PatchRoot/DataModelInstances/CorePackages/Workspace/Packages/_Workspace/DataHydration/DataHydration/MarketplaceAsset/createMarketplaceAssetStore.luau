local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceAssetStoreTypes)

local createDataResolver = require(DataHydration.createDataResolver)

local function createMarketplaceAssetStore() -- line: 10
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
		getMarketplaceAssetInfo = v8.getCachedItem,
		getMarketplaceAssetInfos = v8.getCachedItems,
		updateMarketplaceAssetInfo = v7.updateItem,
		updateMarketplaceAssetInfos = v7.updateItems,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createMarketplaceAssetStore
