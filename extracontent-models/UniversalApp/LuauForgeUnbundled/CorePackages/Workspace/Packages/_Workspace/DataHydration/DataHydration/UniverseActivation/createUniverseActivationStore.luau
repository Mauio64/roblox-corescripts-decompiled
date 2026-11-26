require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local fetchUniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/fetchUniverseActivation")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/UniverseActivationStoreTypes")

local function createUniverseActivationStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createSingleEntityResolver(function(p2)
		return fetchUniverseActivation.fetchEligibility(p2, v6)
	end)

	local v8 = createSingleEntityResolver(function(p2)
		return fetchUniverseActivation.fetchAudiences(p2, v6)
	end)

	return {
		getEligibility = v7.get,
		fetchEligibility = v7.fetch,
		getAndFetchEligibility = v7.getAndFetch,
		refreshEligibility = function(p2)
			return fetchUniverseActivation.fetchEligibility(p2, v6):andThen(function(p3)
				v7.cache.replaceItem(tostring(p2), p3)
				return p3
			end)
		end,
		updateEligibility = v7.update,
		activate = function(p2, p3)
			return fetchUniverseActivation.activate(p2, p3, v6):andThen(function(p4)
				v7.fetch(p2)
				return p4
			end)
		end,
		deactivate = function(p2)
			return fetchUniverseActivation.deactivate(p2, v6):andThen(function(p3)
				v7.fetch(p2)
				return p3
			end)
		end,
		setAudiences = function(p2, p3)
			return fetchUniverseActivation.setAudiences(p2, p3, v6):andThen(function(p4)
				v8.update(p2, p4)
				return p4
			end)
		end,
		getAudiences = v8.get,
		fetchAudiences = v8.fetch,
		getAndFetchAudiences = v8.getAndFetch,
		clear = function()
			v7.clear()
			v8.clear()
		end,
		dispose = function()
			v7.dispose()
			v8.dispose()
		end
	}
end

return createUniverseActivationStore
