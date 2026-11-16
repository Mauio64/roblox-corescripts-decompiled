local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/UniverseConfigurationStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function summaryUrl(p2, p3)
	return ("%s/v1/universes/%d"):format(p2, p3)
end

local function configurationUrl(p2, p3)
	return ("%s/v1/universes/%d/configuration"):format(p2, p3)
end

local function patchConfigurationUrl(p2, p3)
	return ("%s/v2/universes/%d/configuration"):format(p2, p3)
end

local function teamCreateUrl(p2, p3)
	return ("%s/v1/universes/%d/teamcreate"):format(p2, p3)
end

local function resolveBase(options)
	local v5 = options or {}
	return v5.network, v5.baseUrl or urlBase.new("develop")
end

local function resolveMutatingNetwork(options)
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	fetchSummary = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = network,
			method = "GET",
			url = ("%s/v1/universes/%d"):format(baseUrl, p2),
			analyticsKey = "universe-configuration.get-summary",
			legacy = true,
			decode = function(p3)
				return p3
			end
		})))
	end,
	fetchConfiguration = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = network,
			method = "GET",
			url = ("%s/v1/universes/%d/configuration"):format(baseUrl, p2),
			analyticsKey = "universe-configuration.get-configuration",
			legacy = true,
			decode = function(p3)
				return p3
			end
		})))
	end,
	patchConfiguration = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "PATCH",
			url = ("%s/v2/universes/%d/configuration"):format(baseUrl, p2),
			body = p3,
			analyticsKey = "universe-configuration.patch-configuration",
			legacy = true,
			decode = function(p4)
				if p4.studioAccessToApisAllowed ~= nil then
					p4.isStudioAccessToApisAllowed = p4.studioAccessToApisAllowed
				end

				return p4
			end
		})))
	end,
	fetchTeamCreate = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = network,
			method = "GET",
			url = ("%s/v1/universes/%d/teamcreate"):format(baseUrl, p2),
			analyticsKey = "universe-configuration.get-team-create",
			legacy = true,
			decode = function(p3)
				return p3
			end
		})))
	end,
	setTeamCreate = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "PATCH",
			url = ("%s/v1/universes/%d/teamcreate"):format(baseUrl, p2),
			body = { isEnabled = p3 },
			analyticsKey = "universe-configuration.set-team-create",
			legacy = true,
			decode = function(p4)
				return { isEnabled = p3 }
			end
		})))
	end
}
