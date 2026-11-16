require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePermissions/fetchGamePermissions")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePermissions/GamePermissionsStoreTypes")

local function createGamePermissionsStore(options)
	local v5 = options or {}

	local v7 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return fetchGamePermissions.fetchUniversePermissions(tonumber(p2), {
				network = v5.network,
				baseUrl = v5.baseUrl
			})
		end
	})

	return {
		fetchUniversePermissions = function(p2)
			return v7.fetchItem((tostring(p2)))
		end,
		getAndFetchUniversePermissions = function(p2)
			return v7.getAndFetchItem((tostring(p2)))
		end,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createGamePermissionsStore
