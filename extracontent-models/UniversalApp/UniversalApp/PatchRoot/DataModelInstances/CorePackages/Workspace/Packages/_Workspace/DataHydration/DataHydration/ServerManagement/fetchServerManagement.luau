local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.ServerManagementStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(t1: {[any]: any}?) -- line: 21
	-- upvalues: UrlBase (copy)
	local v11 = t1 or {}

	return v11.network, v11.baseUrl or UrlBase.APIS
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 26
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	fetchListRestartStatuses = function(n1: number, t3: {[any]: any}?) -- line: 33
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v15 = t3 or {}
		local network = v15.network
		local v17 = v15.baseUrl or UrlBase.APIS
		local v18 = fetch({
			method = "GET",
			analyticsKey = "server-management.list-restart-statuses",
			network = network,
			url = ("%s%s/universes/%d/restarts"):format(v17, "/server-management/v1", n1),
			decode = function(p1) -- line: 43
				return p1
			end
		})

		return asPromise(v18)
	end,
	fetchForecastRestart = function(n2: number, t4: {[any]: any}?) -- line: 50
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v21 = t4 or {}
		local network = v21.network
		local v23 = v21.baseUrl or UrlBase.APIS
		local v24 = fetch({
			method = "GET",
			analyticsKey = "server-management.forecast-restart",
			network = network,
			url = ("%s%s/universes/%d/restarts:forecast"):format(v23, "/server-management/v1", n2),
			decode = function(p2) -- line: 60
				return p2
			end
		})

		return asPromise(v24)
	end,
	launchRestart = function(n3: number, p3, t5: {[any]: any}?) -- line: 67
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v28 = t5 or {}
		local _ = v28.network
		local v30 = v28.baseUrl or UrlBase.APIS
		local v31 = fetch({
			method = "POST",
			analyticsKey = "server-management.launch-restart",
			network = (t5 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s%s/universes/%d/restarts"):format(v30, "/server-management/v1", n3),
			body = p3 or {},
			decode = function(p4) -- line: 79
				return p4
			end
		})

		return asPromise(v31)
	end
}
