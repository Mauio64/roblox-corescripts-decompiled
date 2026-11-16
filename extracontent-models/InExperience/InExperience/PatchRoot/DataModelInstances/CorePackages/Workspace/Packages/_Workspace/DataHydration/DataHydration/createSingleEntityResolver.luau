local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local v = {}
local v2 = {}

local function createSingleEntityResolver(callback, p)
	local cache = p and p.cache or v
	local resolver = p and p.resolver or v2
	local dataCache = createDataCache(cache.ttlSeconds, cache.failedTtlSeconds, {
		ttlSecondsForItem = cache.ttlSecondsForItem
	})

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(p2: string, _)
			return callback((tonumber(p2)))
		end,
		queueProcessDelaySec = resolver.queueProcessDelaySec,
		requestTimeoutSec = resolver.requestTimeoutSec,
		replaceItems = resolver.replaceItems,
		logError = resolver.logError,
		onClear = resolver.onClear
	})

	return {
		cache = dataCache,
		get = function(p2)
			return dataResolver.getCachedItem((tostring(p2)))
		end,
		fetch = function(p2)
			return dataResolver.fetchItem((tostring(p2)))
		end,
		refetch = function(p2)
			return dataResolver.refetchItem((tostring(p2)))
		end,
		getAndFetch = function(p2)
			return dataResolver.getAndFetchItem((tostring(p2)))
		end,
		update = function(p2, p3)
			dataCache.updateItem(tostring(p2), p3)
		end,
		getAccountResetGeneration = dataResolver.getAccountResetGeneration,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createSingleEntityResolver
