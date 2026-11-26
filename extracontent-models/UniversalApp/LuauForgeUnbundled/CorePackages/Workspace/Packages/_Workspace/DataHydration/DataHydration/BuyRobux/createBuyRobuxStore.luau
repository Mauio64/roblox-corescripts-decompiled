local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/BuyRobux/BuyRobuxStoreTypes")

local function createBuyRobuxStore()
	local v5 = createDataCache()

	return {
		getInfo = v5.getItem,
		updateInfos = v5.replaceItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createBuyRobuxStore
