local DataHydration = script:FindFirstAncestor("DataHydration")
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)
require(script.Parent.GameSubscriptionStoreTypes)

local function createGameSubscriptionStore() -- line: 12
	-- upvalues: createDataCache (copy)
	local v4 = createDataCache()

	return {
		getGameSubscriptionInfo = v4.getItem,
		updateGameSubscriptionInfo = v4.updateItem,
		updateGameSubscriptionInfos = v4.updateItems,
		clear = v4.clear,
		dispose = v4.dispose
	}
end

return createGameSubscriptionStore
