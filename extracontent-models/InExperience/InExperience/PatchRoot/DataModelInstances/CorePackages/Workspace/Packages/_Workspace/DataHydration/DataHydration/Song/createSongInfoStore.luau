local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)

local function createSongInfoStore()
	local dataCache = createDataCache()

	return { getSongInfo = dataCache.getItem, updateSongs = dataCache.updateItems }
end

return createSongInfoStore
