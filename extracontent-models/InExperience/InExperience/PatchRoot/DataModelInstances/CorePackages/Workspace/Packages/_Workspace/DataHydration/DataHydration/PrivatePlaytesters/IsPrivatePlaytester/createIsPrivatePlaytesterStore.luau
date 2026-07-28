local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchIsPrivatePlaytester = require(script.Parent.fetchIsPrivatePlaytester)

require(script.Parent.IsPrivatePlaytesterStoreTypes)

local function createIsPrivatePlaytesterStore(t1: {[any]: any}?) -- line: 18
	-- upvalues: createSingleEntityResolver (copy), fetchIsPrivatePlaytester (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 22
		-- upvalues: fetchIsPrivatePlaytester (copy), t2 (copy)
		return fetchIsPrivatePlaytester(n1, t2)
	end)

	return {
		get = v9.get,
		fetch = v9.fetch,
		getAndFetch = v9.getAndFetch,
		update = v9.update,
		clear = v9.clear,
		dispose = v9.dispose
	}
end

return createIsPrivatePlaytesterStore
