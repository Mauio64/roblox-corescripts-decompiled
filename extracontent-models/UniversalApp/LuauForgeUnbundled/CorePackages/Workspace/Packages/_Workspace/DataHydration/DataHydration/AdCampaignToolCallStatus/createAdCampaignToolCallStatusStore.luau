local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchAdCampaignToolCallStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignToolCallStatus/fetchAdCampaignToolCallStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignToolCallStatus/AdCampaignToolCallStatusStoreTypes")

local function cacheKey(p2, p3)
	return tostring(p2) .. ":" .. p3
end

local function parseCacheKey(value)
	local v5 = string.find(value, ":", 1, true)
	assert(v5 ~= nil, "Invalid ad campaign tool-call status cache key")
	local v6 = tonumber((string.sub(value, 1, v5 - 1)))
	local v7 = string.sub(value, v5 + 1)
	local v8 = v6 ~= nil and v6 > 0 and v7 ~= ""
	assert(v8, "Invalid ad campaign tool-call status cache key")
	return v6, v7
end

local function createAdCampaignToolCallStatusStore(options)
	local v5 = options or {}
	local fetchToolCallStatus = v5.fetchToolCallStatus or fetchAdCampaignToolCallStatus

	local v7 = createDataResolver({
		cache = createDataCache(v5.ttlSeconds or 300),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(value, p2)
			local v8 = string.find(value, ":", 1, true)
			assert(v8 ~= nil, "Invalid ad campaign tool-call status cache key")
			local v9 = tonumber((string.sub(value, 1, v8 - 1)))
			local v10 = string.sub(value, v8 + 1)
			local v11 = v9 ~= nil and v9 > 0 and v10 ~= ""
			assert(v11, "Invalid ad campaign tool-call status cache key")

			return fetchToolCallStatus(v10, v9)
		end
	})

	return {
		getToolCallStatus = function(p2, p3)
			return v7.getCachedItem(tostring(p2) .. ":" .. p3)
		end,
		fetchToolCallStatus = function(p2, p3)
			return v7.fetchItem(tostring(p2) .. ":" .. p3)
		end,
		getAndFetchToolCallStatus = function(p2, p3)
			return v7.getAndFetchItem(tostring(p2) .. ":" .. p3)
		end,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createAdCampaignToolCallStatusStore
