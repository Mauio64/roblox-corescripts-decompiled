local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchIsPrivatePlaytester = require(script.Parent.fetchIsPrivatePlaytester)
require(script.Parent.IsPrivatePlaytesterStoreTypes)

local function createIsPrivatePlaytesterStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchIsPrivatePlaytester(p, v2)
	end)

	return {
		get = singleEntityResolver.get,
		fetch = singleEntityResolver.fetch,
		getAndFetch = singleEntityResolver.getAndFetch,
		update = singleEntityResolver.update,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createIsPrivatePlaytesterStore
