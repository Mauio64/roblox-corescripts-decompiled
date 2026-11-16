local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MediaAssetStoreTypes)

local function createMediaAssetStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getMediaAsset = dataResolver.getCachedItem,
		getMediaAssets = dataResolver.getCachedItems,
		updateMediaAssets = dataCache.updateItems,
		updateMediaAsset = dataCache.updateItem,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createMediaAssetStore
