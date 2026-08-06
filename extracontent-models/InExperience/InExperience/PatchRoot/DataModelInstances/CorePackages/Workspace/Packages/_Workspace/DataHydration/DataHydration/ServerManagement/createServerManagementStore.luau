local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchServerManagement = require(script.Parent.fetchServerManagement)

require(script.Parent.ServerManagementStoreTypes)

local function createServerManagementStore(t1: {[any]: any}?) -- line: 21
	-- upvalues: createSingleEntityResolver (copy), fetchServerManagement (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 25
		-- upvalues: fetchServerManagement (copy), t2 (copy)
		return fetchServerManagement.fetchListRestartStatuses(n1, t2)
	end)
	local v10 = createSingleEntityResolver(function(n2: number) -- line: 28
		-- upvalues: fetchServerManagement (copy), t2 (copy)
		return fetchServerManagement.fetchForecastRestart(n2, t2)
	end)

	return {
		getRestartStatuses = v9.get,
		fetchRestartStatuses = v9.fetch,
		getAndFetchRestartStatuses = v9.getAndFetch,
		getForecast = v10.get,
		fetchForecast = v10.fetch,
		getAndFetchForecast = v10.getAndFetch,
		launchRestart = function(n3: number, p1) -- line: 32
			-- upvalues: fetchServerManagement (copy), t2 (copy), v9 (copy)
			return fetchServerManagement.launchRestart(n3, p1, t2):andThen(function(p2) -- line: 33
				-- upvalues: v9 (copy), n3 (copy)
				v9.fetch(n3)

				return p2
			end)
		end,
		clear = function() -- line: 40
			-- upvalues: v9 (copy), v10 (copy)
			v9.clear()
			v10.clear()
		end,
		dispose = function() -- line: 45
			-- upvalues: v9 (copy), v10 (copy)
			v9.dispose()
			v10.dispose()
		end
	}
end

return createServerManagementStore
