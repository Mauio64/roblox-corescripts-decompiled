require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/fetchCampaignStats")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/CampaignStatsTypes")

local function createCampaignStatsStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl, nowMs = v5.nowMs }

	local v7 = createDataCache(v5.ttlSeconds or 300)

	local v8 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v9 = tonumber(p2)
			return module3.fetchCampaignStats(v9, v6)
		end
	})

	return {
		getCampaignStats = function(p2)
			return v8.getCachedItem((tostring(p2)))
		end,
		fetchCampaignStats = function(p2)
			return v8.fetchItem((tostring(p2)))
		end,
		getAndFetchCampaignStats = function(p2, p3)
			return v8.getAndFetchItem(tostring(p2), p3)
		end,
		isCampaignStatsRequestInQueueOrInFlight = function(p2)
			return v8.isRequestInQueueOrInFlight((tostring(p2)))
		end,
		updateCampaignStats = function(p2, p3)
			v7.replaceItem(tostring(p2), {
				byCampaign = p3,
				failedMetrics = {
					plays = false,
					adClicks = false,
					adViews = false,
					playtimeSeconds = false
				}
			})
		end,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createCampaignStatsStore
