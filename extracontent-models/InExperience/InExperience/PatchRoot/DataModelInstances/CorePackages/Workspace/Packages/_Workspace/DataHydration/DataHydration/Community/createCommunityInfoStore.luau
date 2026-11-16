local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.CommunityInfoStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function createCommunityInfoStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getCommunityInfo = dataResolver.getCachedItem,
		getCommunityInfos = dataResolver.getCachedItems,
		updateCommunityInfo = dataCache.updateItem,
		updateCommunityInfos = dataCache.updateItems,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createCommunityInfoStore
