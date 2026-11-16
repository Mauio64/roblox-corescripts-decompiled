local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchCreatorGroups = require(script.Parent.fetchCreatorGroups)
require(script.Parent.CreatorGroupsStoreTypes)

local function createCreatorGroupsStore(options)
	local v = options or {}

	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			return fetchCreatorGroups(p, { network = v.network, baseUrl = v.baseUrl })
		end
	})

	return {
		getGroups = function(p)
			return dataResolver.getCachedItem(p)
		end,
		fetchGroups = function(p)
			return dataResolver.fetchItem(p)
		end,
		getAndFetchGroups = function(p)
			return dataResolver.getAndFetchItem(p)
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createCreatorGroupsStore
