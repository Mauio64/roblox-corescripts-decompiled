local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Community/CommunityInfoStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

local function createCommunityInfoStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	return {
		getCommunityInfo = v6.getCachedItem,
		getCommunityInfos = v6.getCachedItems,
		updateCommunityInfo = v5.updateItem,
		updateCommunityInfos = v5.updateItems,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createCommunityInfoStore
