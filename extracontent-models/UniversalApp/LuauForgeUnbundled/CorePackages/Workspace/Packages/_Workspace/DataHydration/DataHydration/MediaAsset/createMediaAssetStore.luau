local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MediaAsset/MediaAssetStoreTypes")

local function createMediaAssetStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	return {
		getMediaAsset = v6.getCachedItem,
		getMediaAssets = v6.getCachedItems,
		updateMediaAssets = v5.updateItems,
		updateMediaAsset = v5.updateItem,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createMediaAssetStore
