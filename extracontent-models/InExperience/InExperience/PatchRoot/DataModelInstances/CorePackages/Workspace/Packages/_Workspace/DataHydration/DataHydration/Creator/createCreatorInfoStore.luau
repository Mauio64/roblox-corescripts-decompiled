local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.CreatorInfoStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function createCreatorInfoStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getCreatorInfo = dataResolver.getCachedItem,
		getCreatorInfos = dataResolver.getCachedItems,
		updateCreatorInfo = dataCache.updateItem,
		updateCreatorInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createCreatorInfoStore
