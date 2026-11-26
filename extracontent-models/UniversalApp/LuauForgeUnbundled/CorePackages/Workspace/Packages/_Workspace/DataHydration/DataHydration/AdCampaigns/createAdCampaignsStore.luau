require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/fetchAdCampaigns")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/AdCampaignsTypes")

local function createAdCampaignsStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createDataCache(v5.ttlSeconds or 300)

	local v8 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return module3.fetchAdCampaigns(v6)
		end
	})

	return {
		getAdCampaigns = function()
			return v8.getCachedItem("0")
		end,
		fetchAdCampaigns = function()
			return v8.fetchItem("0")
		end,
		getAndFetchAdCampaigns = function()
			return v8.getAndFetchItem("0")
		end,
		isAdCampaignsRequestInQueueOrInFlight = function()
			return v8.isRequestInQueueOrInFlight("0")
		end,
		updateAdCampaigns = function(p2)
			v7.replaceItem("0", p2)
		end,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createAdCampaignsStore
