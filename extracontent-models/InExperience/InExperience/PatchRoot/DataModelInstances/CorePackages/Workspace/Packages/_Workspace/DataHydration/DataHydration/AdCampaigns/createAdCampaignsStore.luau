local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchAdCampaigns = require(script.Parent.fetchAdCampaigns)
require(script.Parent.AdCampaignsTypes)

local function createAdCampaignsStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local dataCache = createDataCache(v.ttlSeconds or 300)

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_: string, _)
			return fetchAdCampaigns.fetchAdCampaigns(v2)
		end
	})

	return {
		getAdCampaigns = function()
			return dataResolver.getCachedItem("0")
		end,
		fetchAdCampaigns = function()
			return dataResolver.fetchItem("0")
		end,
		getAndFetchAdCampaigns = function()
			return dataResolver.getAndFetchItem("0")
		end,
		isAdCampaignsRequestInQueueOrInFlight = function()
			return dataResolver.isRequestInQueueOrInFlight("0")
		end,
		updateAdCampaigns = function(p)
			dataCache.replaceItem("0", p)
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createAdCampaignsStore
