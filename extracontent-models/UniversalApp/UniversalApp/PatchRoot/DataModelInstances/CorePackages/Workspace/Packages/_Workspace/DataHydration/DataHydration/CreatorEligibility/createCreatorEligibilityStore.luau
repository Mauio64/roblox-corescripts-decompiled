local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchCreatorEligibility = require(script.Parent.fetchCreatorEligibility)

require(script.Parent.CreatorEligibilityStoreTypes)

local function createCreatorEligibilityStore(t1: {[any]: any}?) -- line: 19
	-- upvalues: createSingleEntityResolver (copy), fetchCreatorEligibility (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 23
		-- upvalues: fetchCreatorEligibility (copy), t2 (copy)
		return fetchCreatorEligibility.fetchEligibility(n1, t2)
	end)

	return {
		getEligibility = v9.get,
		fetchEligibility = v9.fetch,
		getAndFetchEligibility = v9.getAndFetch,
		updateEligibility = v9.update,
		clear = v9.clear,
		dispose = v9.dispose
	}
end

return createCreatorEligibilityStore
