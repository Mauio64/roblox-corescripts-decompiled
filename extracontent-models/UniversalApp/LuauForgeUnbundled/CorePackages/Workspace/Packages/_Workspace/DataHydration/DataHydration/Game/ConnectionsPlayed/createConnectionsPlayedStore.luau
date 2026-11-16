local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/ConnectionsPlayed/ConnectionsPlayedStoreTypes")

local function createConnectionsPlayedStore()
	local v5 = createDataCache()

	return {
		getConnectionsPlayed = v5.getItem,
		updateItems = v5.updateItems,
		clear = v5.clear
	}
end

return createConnectionsPlayedStore
