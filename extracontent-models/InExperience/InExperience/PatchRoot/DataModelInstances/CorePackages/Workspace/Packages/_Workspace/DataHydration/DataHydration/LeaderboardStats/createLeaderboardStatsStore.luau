local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.LeaderboardStatsStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function createLeaderboardStatsStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getLeaderboardStats = dataResolver.getCachedItem,
		getLeaderboardStatsBatch = dataResolver.getCachedItems,
		updateLeaderboardStats = dataCache.replaceItem,
		updateLeaderboardStatsBatch = dataCache.replaceItems,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createLeaderboardStatsStore
