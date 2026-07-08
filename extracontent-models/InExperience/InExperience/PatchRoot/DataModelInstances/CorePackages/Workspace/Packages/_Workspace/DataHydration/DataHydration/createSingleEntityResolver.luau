local DataHydration = script:FindFirstAncestor("DataHydration")
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local t1 = {}
local t2 = {}

local function createSingleEntityResolver(p1: ((...any) -> ...any), t3: {[any]: any}?) -- line: 44
	-- upvalues: t1 (copy), t2 (copy), createDataCache (copy), createDataResolver (copy)
	local v9 = t3 and t3.cache or t1
	local v10 = t3 and t3.resolver or t2
	local v11 = createDataCache(v9.ttlSeconds, v9.failedTtlSeconds)
	local v12 = createDataResolver({
		supportsMultiGet = false,
		cache = v11,
		fetchFn = function(s1: string, _) -- line: 54
			-- upvalues: p1 (copy)
			return p1((tonumber(s1)))
		end,
		queueProcessDelaySec = v10.queueProcessDelaySec,
		requestTimeoutSec = v10.requestTimeoutSec,
		logError = v10.logError,
		onClear = v10.onClear
	})

	return {
		cache = v11,
		get = function(p3) -- line: 65
			-- upvalues: v12 (copy)
			return v12.getCachedItem((tostring(p3)))
		end,
		fetch = function(p4) -- line: 68
			-- upvalues: v12 (copy)
			return v12.fetchItem((tostring(p4)))
		end,
		getAndFetch = function(p5) -- line: 71
			-- upvalues: v12 (copy)
			return v12.getAndFetchItem((tostring(p5)))
		end,
		update = function(p6, p7) -- line: 74
			-- upvalues: v11 (copy)
			v11.updateItem(tostring(p6), p7)
		end,
		clear = v12.clear,
		dispose = v12.dispose
	}
end

return createSingleEntityResolver
