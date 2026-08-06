local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchUniverseActivation = require(script.Parent.fetchUniverseActivation)

require(script.Parent.UniverseActivationStoreTypes)

local function createUniverseActivationStore(t1: {[any]: any}?) -- line: 19
	-- upvalues: createSingleEntityResolver (copy), fetchUniverseActivation (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 23
		-- upvalues: fetchUniverseActivation (copy), t2 (copy)
		return fetchUniverseActivation.fetchEligibility(n1, t2)
	end)
	local v10 = createSingleEntityResolver(function(n2: number) -- line: 26
		-- upvalues: fetchUniverseActivation (copy), t2 (copy)
		return fetchUniverseActivation.fetchAudiences(n2, t2)
	end)

	return {
		getEligibility = v9.get,
		fetchEligibility = v9.fetch,
		getAndFetchEligibility = v9.getAndFetch,
		refreshEligibility = function(n3: number) -- line: 32
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v9 (copy)
			return fetchUniverseActivation.fetchEligibility(n3, t2):andThen(function(p1) -- line: 35
				-- upvalues: v9 (copy), n3 (copy)
				v9.cache.replaceItem(tostring(n3), p1)

				return p1
			end)
		end,
		updateEligibility = v9.update,
		activate = function(n4: number, p2) -- line: 41
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v9 (copy)
			return fetchUniverseActivation.activate(n4, p2, t2):andThen(function(p3) -- line: 42
				-- upvalues: v9 (copy), n4 (copy)
				v9.fetch(n4)

				return p3
			end)
		end,
		deactivate = function(n5: number) -- line: 48
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v9 (copy)
			return fetchUniverseActivation.deactivate(n5, t2):andThen(function(p4) -- line: 49
				-- upvalues: v9 (copy), n5 (copy)
				v9.fetch(n5)

				return p4
			end)
		end,
		setAudiences = function(n6: number, t3: {[any]: any}) -- line: 55
			-- upvalues: fetchUniverseActivation (copy), t2 (copy), v10 (copy)
			return fetchUniverseActivation.setAudiences(n6, t3, t2):andThen(function(p5) -- line: 58
				-- upvalues: v10 (copy), n6 (copy)
				v10.update(n6, p5)

				return p5
			end)
		end,
		getAudiences = v10.get,
		fetchAudiences = v10.fetch,
		getAndFetchAudiences = v10.getAndFetch,
		clear = function() -- line: 64
			-- upvalues: v9 (copy), v10 (copy)
			v9.clear()
			v10.clear()
		end,
		dispose = function() -- line: 69
			-- upvalues: v9 (copy), v10 (copy)
			v9.dispose()
			v10.dispose()
		end
	}
end

return createUniverseActivationStore
