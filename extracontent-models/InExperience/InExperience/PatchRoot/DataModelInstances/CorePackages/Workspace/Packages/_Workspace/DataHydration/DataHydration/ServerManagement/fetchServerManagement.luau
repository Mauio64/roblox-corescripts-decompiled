local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.ServerManagementStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(options) -- 3 equivalent calls inferred from this helper
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.APIS
end

local function resolveMutatingNetwork(options) -- 1 equivalent call inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local FetchServerManagement = {}

function FetchServerManagement.fetchListRestartStatuses(p: number, options)
	local base, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = base,
		method = "GET",
		url = ("%s%s/universes/%d/restarts"):format(v, "/server-management/v1", p),
		analyticsKey = "server-management.list-restart-statuses",
		decode = function(p2)
			return p2
		end
	})))
end

function FetchServerManagement.fetchForecastRestart(p: number, options)
	local base, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = base,
		method = "GET",
		url = ("%s%s/universes/%d/restarts:forecast"):format(v, "/server-management/v1", p),
		analyticsKey = "server-management.forecast-restart",
		decode = function(p2)
			return p2
		end
	})))
end

function FetchServerManagement.launchRestart(p: number, options, options2)
	local _, v = resolveBase(options2) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options2), -- inferred equivalent call
		method = "POST",
		url = ("%s%s/universes/%d/restarts"):format(v, "/server-management/v1", p),
		body = options or {},
		analyticsKey = "server-management.launch-restart",
		decode = function(p2)
			return p2
		end
	})))
end

return FetchServerManagement
