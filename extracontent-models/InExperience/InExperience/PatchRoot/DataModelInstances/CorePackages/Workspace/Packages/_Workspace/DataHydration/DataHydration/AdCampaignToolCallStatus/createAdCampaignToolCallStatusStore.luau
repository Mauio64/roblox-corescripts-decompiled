local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchAdCampaignToolCallStatus = require(script.Parent.fetchAdCampaignToolCallStatus)
require(script.Parent.AdCampaignToolCallStatusStoreTypes)

local function cacheKey(p: number, p2: string) -- 3 equivalent calls inferred from this helper
	return tostring(p) .. ":" .. p2
end

local function parseCacheKey(value: string) -- 1 equivalent call inferred from this helper
	local v = string.find(value, ":", 1, true)
	assert(v ~= nil, "Invalid ad campaign tool-call status cache key")
	local v2 = tonumber((string.sub(value, 1, v - 1)))
	local v3 = string.sub(value, v + 1)
	local v4 = v2 ~= nil and v2 > 0 and v3 ~= ""
	assert(v4, "Invalid ad campaign tool-call status cache key")
	return v2, v3
end

local function createAdCampaignToolCallStatusStore(options)
	local v = options or {}
	local fetchToolCallStatus = v.fetchToolCallStatus or fetchAdCampaignToolCallStatus

	local dataResolver = createDataResolver({
		cache = createDataCache(v.ttlSeconds or 300),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(value: string, _)
			local cacheKey2, v2 = parseCacheKey(value) -- inferred equivalent call
			return fetchToolCallStatus(v2, cacheKey2)
		end
	})

	return {
		getToolCallStatus = function(p, p2)
			return dataResolver.getCachedItem(cacheKey(p, p2)) -- inferred equivalent call
		end,
		fetchToolCallStatus = function(p, p2)
			return dataResolver.fetchItem(cacheKey(p, p2)) -- inferred equivalent call
		end,
		getAndFetchToolCallStatus = function(p, p2)
			return dataResolver.getAndFetchItem(cacheKey(p, p2)) -- inferred equivalent call
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createAdCampaignToolCallStatusStore
