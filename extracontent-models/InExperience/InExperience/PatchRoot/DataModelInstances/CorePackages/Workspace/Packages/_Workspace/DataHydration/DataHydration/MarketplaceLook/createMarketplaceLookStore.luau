local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceLookStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)
local SharedFlags = require(parent.SharedFlags)
local FFlagDataHydrationAccountReset = SharedFlags.FFlagDataHydrationAccountReset

local function createMarketplaceLookStore()
	local dataCache = createDataCache(nil, nil, FFlagDataHydrationAccountReset and {
		observeLocalUser = false
	} or nil)

	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end,
		keepCacheOnAccountReset = FFlagDataHydrationAccountReset and true or nil
	})

	return {
		getMarketplaceLookInfo = dataResolver.getCachedItem,
		getMarketplaceLookInfos = dataResolver.getCachedItems,
		updateMarketplaceLookInfo = dataCache.updateItem,
		updateMarketplaceLookInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createMarketplaceLookStore
