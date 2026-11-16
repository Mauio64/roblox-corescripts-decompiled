local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceLook/MarketplaceLookStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local fFlagDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagDataHydrationAccountReset

local function createMarketplaceLookStore()
	local v5 = createDataCache(nil, nil, fFlagDataHydrationAccountReset and {
		observeLocalUser = false
	} or nil)

	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end,
		keepCacheOnAccountReset = fFlagDataHydrationAccountReset and true or nil
	})

	return {
		getMarketplaceLookInfo = v6.getCachedItem,
		getMarketplaceLookInfos = v6.getCachedItems,
		updateMarketplaceLookInfo = v5.updateItem,
		updateMarketplaceLookInfos = v5.updateItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createMarketplaceLookStore
