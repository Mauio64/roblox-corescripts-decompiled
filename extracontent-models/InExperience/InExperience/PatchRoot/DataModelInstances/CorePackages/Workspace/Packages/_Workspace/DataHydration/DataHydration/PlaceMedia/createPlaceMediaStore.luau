local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchPlaceMedia = require(script.Parent.fetchPlaceMedia)
require(script.Parent.PlaceMediaStoreTypes)

local function createPlaceMediaStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchPlaceMedia.fetchMedia(p, v2)
	end)

	return {
		getMedia = singleEntityResolver.get,
		fetchMedia = singleEntityResolver.fetch,
		getAndFetchMedia = singleEntityResolver.getAndFetch,
		updateMedia = singleEntityResolver.update,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createPlaceMediaStore
