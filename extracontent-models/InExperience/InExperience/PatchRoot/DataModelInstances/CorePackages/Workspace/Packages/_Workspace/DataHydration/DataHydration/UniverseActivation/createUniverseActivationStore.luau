local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchUniverseActivation = require(script.Parent.fetchUniverseActivation)
require(script.Parent.UniverseActivationStoreTypes)

local function createUniverseActivationStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchUniverseActivation.fetchEligibility(p, v2)
	end)

	local singleEntityResolver2 = createSingleEntityResolver(function(p: number)
		return fetchUniverseActivation.fetchAudiences(p, v2)
	end)

	return {
		getEligibility = singleEntityResolver.get,
		fetchEligibility = singleEntityResolver.fetch,
		getAndFetchEligibility = singleEntityResolver.getAndFetch,
		refreshEligibility = function(p: number)
			return fetchUniverseActivation.fetchEligibility(p, v2):andThen(function(p2)
				singleEntityResolver.cache.replaceItem(tostring(p), p2)
				return p2
			end)
		end,
		updateEligibility = singleEntityResolver.update,
		activate = function(p: number, p2)
			return fetchUniverseActivation.activate(p, p2, v2):andThen(function(p3)
				singleEntityResolver.fetch(p)
				return p3
			end)
		end,
		deactivate = function(p: number)
			return fetchUniverseActivation.deactivate(p, v2):andThen(function(p2)
				singleEntityResolver.fetch(p)
				return p2
			end)
		end,
		setAudiences = function(p: number, p2)
			return fetchUniverseActivation.setAudiences(p, p2, v2):andThen(function(p3)
				singleEntityResolver2.update(p, p3)
				return p3
			end)
		end,
		getAudiences = singleEntityResolver2.get,
		fetchAudiences = singleEntityResolver2.fetch,
		getAndFetchAudiences = singleEntityResolver2.getAndFetch,
		clear = function()
			singleEntityResolver.clear()
			singleEntityResolver2.clear()
		end,
		dispose = function()
			singleEntityResolver.dispose()
			singleEntityResolver2.dispose()
		end
	}
end

return createUniverseActivationStore
