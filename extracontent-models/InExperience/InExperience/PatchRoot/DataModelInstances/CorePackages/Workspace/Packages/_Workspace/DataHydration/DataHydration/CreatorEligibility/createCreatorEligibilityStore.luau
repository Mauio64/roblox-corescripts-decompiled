local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchCreatorEligibility = require(script.Parent.fetchCreatorEligibility)
require(script.Parent.CreatorEligibilityStoreTypes)

local function createCreatorEligibilityStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchCreatorEligibility.fetchEligibility(p, v2)
	end)

	return {
		getEligibility = singleEntityResolver.get,
		fetchEligibility = singleEntityResolver.fetch,
		getAndFetchEligibility = singleEntityResolver.getAndFetch,
		updateEligibility = singleEntityResolver.update,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createCreatorEligibilityStore
