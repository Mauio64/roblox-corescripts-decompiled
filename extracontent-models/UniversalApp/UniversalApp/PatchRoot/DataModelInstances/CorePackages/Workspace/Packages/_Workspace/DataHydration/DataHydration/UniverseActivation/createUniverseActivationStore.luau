local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchUniverseActivation = require(script.Parent.fetchUniverseActivation)

require(script.Parent.UniverseActivationStoreTypes)

local function createUniverseActivationStore(t1: {[any]: any}?) -- line: 20
	-- upvalues: createSingleEntityResolver (copy), fetchUniverseActivation (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 24
		-- upvalues: fetchUniverseActivation (copy), t2 (copy)
		return fetchUniverseActivation.fetchEligibility(n1, t2)
	end)
	local v10 = createSingleEntityResolver(function(n2: number) -- line: 27
		-- upvalues: fetchUniverseActivation (copy), t2 (copy)
		return fetchUniverseActivation.fetchAudiences(n2, t2)
	end)

	return {
		getEligibility = v9.get,
		fetchEligibility = v9.fetch,
		getAndFetchEligibility = v9.getAndFetch,
		updateEligibility = v9.update,
		activate = function(n3: number, p1) -- line: 31
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v9 (copy)
			return fetchUniverseActivation.activate(n3, p1, t2):andThen(function(p2) -- line: 32
				-- upvalues: v9 (copy), n3 (copy)
				v9.fetch(n3)

				return p2
			end)
		end,
		deactivate = function(n4: number) -- line: 38
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v9 (copy)
			return fetchUniverseActivation.deactivate(n4, t2):andThen(function(p3) -- line: 39
				-- upvalues: v9 (copy), n4 (copy)
				v9.fetch(n4)

				return p3
			end)
		end,
		setAudiences = function(n5: number, t3: {[any]: any}) -- line: 45
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v10 (copy)
			return fetchUniverseActivation.setAudiences(n5, t3, t2):andThen(function(p4) -- line: 48
				-- upvalues: v10 (copy), n5 (copy)
				v10.update(n5, p4)

				return p4
			end)
		end,
		getAudiences = v10.get,
		fetchAudiences = v10.fetch,
		getAndFetchAudiences = v10.getAndFetch,
		clear = function() -- line: 54
			-- upvalues: v9 (copy), v10 (copy)
			v9.clear()
			v10.clear()
		end,
		dispose = function() -- line: 59
			-- upvalues: v9 (copy), v10 (copy)
			v9.dispose()
			v10.dispose()
		end
	}
end

return createUniverseActivationStore
