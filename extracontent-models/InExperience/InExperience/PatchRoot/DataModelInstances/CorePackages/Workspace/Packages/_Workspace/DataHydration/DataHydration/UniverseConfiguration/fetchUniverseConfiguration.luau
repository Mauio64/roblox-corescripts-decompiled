local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.UniverseConfigurationStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function summaryUrl(baseUrl: string, p: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/universes/%d"):format(baseUrl, p)
end

local function configurationUrl(baseUrl: string, p: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/universes/%d/configuration"):format(baseUrl, p)
end

local function patchConfigurationUrl(p: string, p2: number) -- 1 equivalent call inferred from this helper
	return ("%s/v2/universes/%d/configuration"):format(p, p2)
end

local function teamCreateUrl(p: string, p2: number) -- 2 equivalent calls inferred from this helper
	return ("%s/v1/universes/%d/teamcreate"):format(p, p2)
end

local function resolveBase(options) -- 2 equivalent calls inferred from this helper
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.new("develop")
end

local function resolveMutatingNetwork(options) -- 2 equivalent calls inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local FetchUniverseConfiguration = {}

function FetchUniverseConfiguration.fetchSummary(p: number, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = summaryUrl(v.baseUrl or UrlBase.new("develop"), p), -- inferred equivalent call
		analyticsKey = "universe-configuration.get-summary",
		legacy = true,
		decode = function(p2)
			return p2
		end
	})))
end

function FetchUniverseConfiguration.fetchConfiguration(p: number, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = configurationUrl(v.baseUrl or UrlBase.new("develop"), p), -- inferred equivalent call
		analyticsKey = "universe-configuration.get-configuration",
		legacy = true,
		decode = function(p2)
			return p2
		end
	})))
end

function FetchUniverseConfiguration.patchConfiguration(p: number, body, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "PATCH",
		url = patchConfigurationUrl(v, p), -- inferred equivalent call
		body = body,
		analyticsKey = "universe-configuration.patch-configuration",
		legacy = true,
		decode = function(p2)
			if p2.studioAccessToApisAllowed ~= nil then
				p2.isStudioAccessToApisAllowed = p2.studioAccessToApisAllowed
			end

			return p2
		end
	})))
end

function FetchUniverseConfiguration.fetchTeamCreate(p: number, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = teamCreateUrl(v.baseUrl or UrlBase.new("develop"), p), -- inferred equivalent call
		analyticsKey = "universe-configuration.get-team-create",
		legacy = true,
		decode = function(p2)
			return p2
		end
	})))
end

function FetchUniverseConfiguration.setTeamCreate(p: number, isEnabled: boolean, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "PATCH",
		url = teamCreateUrl(v, p), -- inferred equivalent call
		body = { isEnabled = isEnabled },
		analyticsKey = "universe-configuration.set-team-create",
		legacy = true,
		decode = function(_)
			return { isEnabled = isEnabled }
		end
	})))
end

return FetchUniverseConfiguration
