local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local v5 = {}
local v6 = {}

local function createSingleEntityResolver(callback, p2)
	local cache = p2 and p2.cache or v5
	local resolver = p2 and p2.resolver or v6
	local v7 = createDataCache(cache.ttlSeconds, cache.failedTtlSeconds, {
		ttlSecondsForItem = cache.ttlSecondsForItem
	})

	local v8 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		fetchFn = function(p3, p4)
			return callback((tonumber(p3)))
		end,
		queueProcessDelaySec = resolver.queueProcessDelaySec,
		requestTimeoutSec = resolver.requestTimeoutSec,
		replaceItems = resolver.replaceItems,
		logError = resolver.logError,
		onClear = resolver.onClear
	})

	return {
		cache = v7,
		get = function(p3)
			return v8.getCachedItem((tostring(p3)))
		end,
		fetch = function(p3)
			return v8.fetchItem((tostring(p3)))
		end,
		refetch = function(p3)
			return v8.refetchItem((tostring(p3)))
		end,
		getAndFetch = function(p3)
			return v8.getAndFetchItem((tostring(p3)))
		end,
		update = function(p3, p4)
			v7.updateItem(tostring(p3), p4)
		end,
		getAccountResetGeneration = v8.getAccountResetGeneration,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createSingleEntityResolver
