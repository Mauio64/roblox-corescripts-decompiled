local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)

require(script.Parent.ConnectionsPlayedStoreTypes)

local function createConnectionsPlayedStore()
	local dataCache = createDataCache()

	return {
		getConnectionsPlayed = dataCache.getItem,
		updateItems = dataCache.updateItems,
		clear = dataCache.clear
	}
end

return createConnectionsPlayedStore
