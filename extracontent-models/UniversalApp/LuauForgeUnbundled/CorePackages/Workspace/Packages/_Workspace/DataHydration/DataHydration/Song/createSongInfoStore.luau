local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local function createSongInfoStore()
	local v5 = createDataCache()

	return { getSongInfo = v5.getItem, updateSongs = v5.updateItems }
end

return createSongInfoStore
