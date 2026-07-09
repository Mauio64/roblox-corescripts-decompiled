local DataHydration = script:FindFirstAncestor("DataHydration")
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)

local function createSongInfoStore() -- line: 14
	-- upvalues: createDataCache (copy)
	local v4 = createDataCache()

	return {
		getSongInfo = v4.getItem,
		updateSongs = v4.updateItems
	}
end

return createSongInfoStore
