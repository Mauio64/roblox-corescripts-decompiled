local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)

require(script.Parent.BuyRobuxStoreTypes)

local function createBuyRobuxStore()
	local dataCache = createDataCache()

	return {
		getInfo = dataCache.getItem,
		updateInfos = dataCache.replaceItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createBuyRobuxStore
