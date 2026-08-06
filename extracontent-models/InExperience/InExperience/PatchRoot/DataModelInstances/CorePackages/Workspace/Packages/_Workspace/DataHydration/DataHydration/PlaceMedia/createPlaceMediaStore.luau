local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchPlaceMedia = require(script.Parent.fetchPlaceMedia)

require(script.Parent.PlaceMediaStoreTypes)

local function createPlaceMediaStore(t1: {[any]: any}?) -- line: 18
	-- upvalues: createSingleEntityResolver (copy), fetchPlaceMedia (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 22
		-- upvalues: fetchPlaceMedia (copy), t2 (copy)
		return fetchPlaceMedia.fetchMedia(n1, t2)
	end)

	return {
		getMedia = v9.get,
		fetchMedia = v9.fetch,
		getAndFetchMedia = v9.getAndFetch,
		updateMedia = v9.update,
		clear = v9.clear,
		dispose = v9.dispose
	}
end

return createPlaceMediaStore
