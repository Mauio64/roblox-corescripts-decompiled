local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MediaAssetStoreTypes)

local function createMediaAssetStore() -- line: 17
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy)
	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		fetchFn = function(_: {[any]: any}) -- line: 21
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})

	return {
		getMediaAsset = v8.getCachedItem,
		getMediaAssets = v8.getCachedItems,
		updateMediaAssets = v7.updateItems,
		updateMediaAsset = v7.updateItem,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createMediaAssetStore
