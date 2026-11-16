local DataHydration = script:FindFirstAncestor("DataHydration")

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
require(DataHydration.DataHydrationTypes)
local fetchLookByOutfit = require(script.Parent.Requests.fetchLookByOutfit)

local function createOutfitLookStore(p)
	local singleEntityResolver = createSingleEntityResolver(function(p2: number)
		return fetchLookByOutfit(p2, p)
	end, {
		resolver = { replaceItems = true }
	})

	return {
		getCachedLookByOutfit = singleEntityResolver.get,
		getAndFetchLookByOutfit = singleEntityResolver.getAndFetch,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createOutfitLookStore
