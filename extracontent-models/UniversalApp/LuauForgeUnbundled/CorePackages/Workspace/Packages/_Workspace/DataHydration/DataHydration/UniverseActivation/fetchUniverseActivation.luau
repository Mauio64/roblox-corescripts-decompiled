local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/UniverseActivationStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function eligibilityUrl(p2, p3)
	return ("%s/v1/universes/%d/activation-eligibility"):format(p2, p3)
end

local function activateUrl(p2, p3)
	return ("%s/v1/universes/%d/activate"):format(p2, p3)
end

local function deactivateUrl(p2, p3)
	return ("%s/v1/universes/%d/deactivate"):format(p2, p3)
end

local function v2ConfigurationUrl(p2, p3)
	return ("%s/v2/universes/%d/configuration"):format(p2, p3)
end

local function resolveBase(options)
	local v5 = options or {}
	return v5.network, v5.baseUrl or urlBase.new("develop")
end

local function resolveMutatingNetwork(options)
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	fetchEligibility = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = network,
			method = "GET",
			url = ("%s/v1/universes/%d/activation-eligibility"):format(baseUrl, p2),
			analyticsKey = "universe-activation.get-eligibility",
			legacy = true,
			decode = function(p3)
				return p3
			end
		})))
	end,
	activate = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")

		local v6 = {}

		if p3 and p3.versionId ~= nil then
			v6.versionId = p3.versionId
		end

		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "POST",
			url = ("%s/v1/universes/%d/activate"):format(baseUrl, p2),
			body = v6,
			analyticsKey = "universe-activation.activate",
			legacy = true,
			decode = function(p4)
				return { isActive = true }
			end
		})))
	end,
	deactivate = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "POST",
			url = ("%s/v1/universes/%d/deactivate"):format(baseUrl, p2),
			body = {},
			analyticsKey = "universe-activation.deactivate",
			legacy = true,
			decode = function(p3)
				return { isActive = false }
			end
		})))
	end,
	fetchAudiences = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = network,
			method = "GET",
			url = ("%s/v2/universes/%d/configuration"):format(baseUrl, p2),
			analyticsKey = "universe-activation.get-audiences",
			legacy = true,
			decode = function(p3)
				return p3
			end
		})))
	end,
	setAudiences = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "PATCH",
			url = ("%s/v2/universes/%d/configuration"):format(baseUrl, p2),
			body = { audiences = p3 },
			analyticsKey = "universe-activation.set-audiences",
			legacy = true,
			decode = function(p4)
				if p4 and typeof(p4) == "table" and p4.audiences ~= nil then
					return p4
				end

				return { id = p2, audiences = p3 }
			end
		})))
	end
}
