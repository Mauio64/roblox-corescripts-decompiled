local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchCampaignStats = require(script.Parent.fetchCampaignStats)
require(script.Parent.CampaignStatsTypes)

local function createCampaignStatsStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl, nowMs = v.nowMs }

	local dataCache = createDataCache(v.ttlSeconds or 300)

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			local v3 = tonumber(p)
			return fetchCampaignStats.fetchCampaignStats(v3, v2)
		end
	})

	return {
		getCampaignStats = function(p: number)
			return dataResolver.getCachedItem((tostring(p)))
		end,
		fetchCampaignStats = function(p: number)
			return dataResolver.fetchItem((tostring(p)))
		end,
		getAndFetchCampaignStats = function(p: number, callback)
			return dataResolver.getAndFetchItem(tostring(p), callback)
		end,
		isCampaignStatsRequestInQueueOrInFlight = function(p: number)
			return dataResolver.isRequestInQueueOrInFlight((tostring(p)))
		end,
		updateCampaignStats = function(p: number, byCampaign)
			dataCache.replaceItem(tostring(p), {
				byCampaign = byCampaign,
				failedMetrics = {
					plays = false,
					adClicks = false,
					adViews = false,
					playtimeSeconds = false
				}
			})
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createCampaignStatsStore
