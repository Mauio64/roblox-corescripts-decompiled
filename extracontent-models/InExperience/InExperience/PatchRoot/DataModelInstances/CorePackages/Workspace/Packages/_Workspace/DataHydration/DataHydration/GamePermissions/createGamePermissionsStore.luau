local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchGamePermissions = require(script.Parent.fetchGamePermissions)
require(script.Parent.GamePermissionsStoreTypes)

local function createGamePermissionsStore(options)
	local v = options or {}

	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			return fetchGamePermissions.fetchUniversePermissions(tonumber(p), {
				network = v.network,
				baseUrl = v.baseUrl
			})
		end
	})

	return {
		fetchUniversePermissions = function(p: number)
			return dataResolver.fetchItem((tostring(p)))
		end,
		getAndFetchUniversePermissions = function(p: number)
			return dataResolver.getAndFetchItem((tostring(p)))
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createGamePermissionsStore
