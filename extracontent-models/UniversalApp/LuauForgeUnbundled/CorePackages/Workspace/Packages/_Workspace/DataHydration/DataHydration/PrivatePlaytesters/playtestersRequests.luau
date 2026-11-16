local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function playtestersUrl(p2, p3)
	return ("%s/v1/universes/%d/configuration/playtesters"):format(p2, p3)
end

local function resolveBase(options)
	local v5 = options or {}
	return v5.network, v5.baseUrl or urlBase.new("develop")
end

local function resolveMutatingNetwork(options)
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function decodePlaytesterIds(p2)
	local result = {}
	local playtesters = if type(p2) == "table" then p2.playtesters else nil

	if type(playtesters) ~= "table" then
		return result
	end

	for k, playtester in playtesters do
		if type(playtester) == "number" then
			table.insert(result, playtester)
		elseif type(playtester) == "table" then
			local userId = playtester.userId or playtester.id

			if type(userId) == "number" then
				table.insert(result, userId)
			end
		end
	end

	return result
end

return {
	fetchPlaytesters = function(p2, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = network,
			method = "GET",
			url = ("%s/v1/universes/%d/configuration/playtesters"):format(baseUrl, p2),
			analyticsKey = "private-playtesters.fetch",
			legacy = true,
			decode = decodePlaytesterIds
		})))
	end,
	addPlaytester = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "POST",
			url = ("%s/v1/universes/%d/configuration/playtesters"):format(baseUrl, p2),
			body = { playtesters = p3 },
			analyticsKey = "private-playtesters.add",
			legacy = true,
			decode = decodePlaytesterIds
		})))
	end,
	removePlaytester = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local baseUrl = v5.baseUrl or urlBase.new("develop")
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "DELETE",
			url = ("%s/v1/universes/%d/configuration/playtesters"):format(baseUrl, p2),
			body = {
				playtesters = { p3 }
			},
			analyticsKey = "private-playtesters.remove",
			legacy = true,
			decode = decodePlaytesterIds
		})))
	end
}
