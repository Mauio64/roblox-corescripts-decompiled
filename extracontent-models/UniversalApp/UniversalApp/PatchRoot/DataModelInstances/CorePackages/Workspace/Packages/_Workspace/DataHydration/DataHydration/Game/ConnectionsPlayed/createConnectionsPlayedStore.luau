local DataHydration = script:FindFirstAncestor("DataHydration")
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)
require(script.Parent.ConnectionsPlayedStoreTypes)

local function createConnectionsPlayedStore() -- line: 11
	-- upvalues: createDataCache (copy)
	local v4 = createDataCache()

	return {
		getConnectionsPlayed = v4.getItem,
		updateItems = v4.updateItems,
		clear = v4.clear
	}
end

return createConnectionsPlayedStore
