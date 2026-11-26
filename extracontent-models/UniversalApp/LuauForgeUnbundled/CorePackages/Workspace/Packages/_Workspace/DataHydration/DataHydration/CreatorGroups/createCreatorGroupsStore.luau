require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchCreatorGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/fetchCreatorGroups")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/CreatorGroupsStoreTypes")

local function createCreatorGroupsStore(options)
	local v5 = options or {}

	local v7 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return fetchCreatorGroups(p2, { network = v5.network, baseUrl = v5.baseUrl })
		end
	})

	return {
		getGroups = function(p2)
			return v7.getCachedItem(p2)
		end,
		fetchGroups = function(p2)
			return v7.fetchItem(p2)
		end,
		getAndFetchGroups = function(p2)
			return v7.getAndFetchItem(p2)
		end,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createCreatorGroupsStore
