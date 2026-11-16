local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)

require(script.Parent.GameSubscriptionStoreTypes)

local function createGameSubscriptionStore()
	local dataCache = createDataCache()

	return {
		getGameSubscriptionInfo = dataCache.getItem,
		updateGameSubscriptionInfo = dataCache.updateItem,
		updateGameSubscriptionInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createGameSubscriptionStore
