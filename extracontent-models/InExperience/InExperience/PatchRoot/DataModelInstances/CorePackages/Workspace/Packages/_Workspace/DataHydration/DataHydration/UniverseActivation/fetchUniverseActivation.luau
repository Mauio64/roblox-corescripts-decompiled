local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.UniverseActivationStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function eligibilityUrl(p: string, p2: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/universes/%d/activation-eligibility"):format(p, p2)
end

local function activateUrl(p: string, p2: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/universes/%d/activate"):format(p, p2)
end

local function deactivateUrl(p: string, p2: number) -- 1 equivalent call inferred from this helper
	return ("%s/v1/universes/%d/deactivate"):format(p, p2)
end

local function v2ConfigurationUrl(p: string, p2: number) -- 2 equivalent calls inferred from this helper
	return ("%s/v2/universes/%d/configuration"):format(p, p2)
end

local function resolveBase(options) -- 5 equivalent calls inferred from this helper
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.new("develop")
end

local function resolveMutatingNetwork(options) -- 3 equivalent calls inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local FetchUniverseActivation = {}

function FetchUniverseActivation.fetchEligibility(p: number, options)
	local base, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = base,
		method = "GET",
		url = eligibilityUrl(v, p), -- inferred equivalent call
		analyticsKey = "universe-activation.get-eligibility",
		legacy = true,
		decode = function(p2)
			return p2
		end
	})))
end

function FetchUniverseActivation.activate(p: number, p2, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	local body = {}

	if p2 and p2.versionId ~= nil then
		body.versionId = p2.versionId
	end

	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = activateUrl(v, p), -- inferred equivalent call
		body = body,
		analyticsKey = "universe-activation.activate",
		legacy = true,
		decode = function(_)
			return { isActive = true }
		end
	})))
end

function FetchUniverseActivation.deactivate(p: number, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = deactivateUrl(v, p), -- inferred equivalent call
		body = {},
		analyticsKey = "universe-activation.deactivate",
		legacy = true,
		decode = function(_)
			return { isActive = false }
		end
	})))
end

function FetchUniverseActivation.fetchAudiences(p: number, options)
	local base, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = base,
		method = "GET",
		url = v2ConfigurationUrl(v, p), -- inferred equivalent call
		analyticsKey = "universe-activation.get-audiences",
		legacy = true,
		decode = function(p2)
			return p2
		end
	})))
end

function FetchUniverseActivation.setAudiences(id: number, audiences, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "PATCH",
		url = v2ConfigurationUrl(v, id), -- inferred equivalent call
		body = { audiences = audiences },
		analyticsKey = "universe-activation.set-audiences",
		legacy = true,
		decode = function(p)
			if p and typeof(p) == "table" and p.audiences ~= nil then
				return p
			end

			return { id = id, audiences = audiences }
		end
	})))
end

return FetchUniverseActivation
