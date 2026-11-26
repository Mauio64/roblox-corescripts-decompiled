local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/LeaderboardStats/LeaderboardStatsStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

local function createLeaderboardStatsStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	return {
		getLeaderboardStats = v6.getCachedItem,
		getLeaderboardStatsBatch = v6.getCachedItems,
		updateLeaderboardStats = v5.replaceItem,
		updateLeaderboardStatsBatch = v5.replaceItems,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createLeaderboardStatsStore
