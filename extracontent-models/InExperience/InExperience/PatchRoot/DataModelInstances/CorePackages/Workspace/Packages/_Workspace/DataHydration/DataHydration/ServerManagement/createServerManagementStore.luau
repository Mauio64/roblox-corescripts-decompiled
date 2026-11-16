local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchServerManagement = require(script.Parent.fetchServerManagement)
require(script.Parent.ServerManagementStoreTypes)

local function createServerManagementStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchServerManagement.fetchListRestartStatuses(p, v2)
	end)

	local singleEntityResolver2 = createSingleEntityResolver(function(p: number)
		return fetchServerManagement.fetchForecastRestart(p, v2)
	end)

	return {
		getRestartStatuses = singleEntityResolver.get,
		fetchRestartStatuses = singleEntityResolver.fetch,
		getAndFetchRestartStatuses = singleEntityResolver.getAndFetch,
		getForecast = singleEntityResolver2.get,
		fetchForecast = singleEntityResolver2.fetch,
		getAndFetchForecast = singleEntityResolver2.getAndFetch,
		launchRestart = function(p: number, p2)
			return fetchServerManagement.launchRestart(p, p2, v2):andThen(function(p3)
				singleEntityResolver.fetch(p)
				return p3
			end)
		end,
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

return createServerManagementStore
