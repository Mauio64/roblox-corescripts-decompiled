local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameSubscription/GameSubscriptionStoreTypes")

local function createGameSubscriptionStore()
	local v5 = createDataCache()

	return {
		getGameSubscriptionInfo = v5.getItem,
		updateGameSubscriptionInfo = v5.updateItem,
		updateGameSubscriptionInfos = v5.updateItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createGameSubscriptionStore
