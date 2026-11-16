local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function playtestersUrl(p: string, p2: number) -- 3 equivalent calls inferred from this helper
	return ("%s/v1/universes/%d/configuration/playtesters"):format(p, p2)
end

local function resolveBase(options) -- 2 equivalent calls inferred from this helper
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.new("develop")
end

local function resolveMutatingNetwork(options) -- 2 equivalent calls inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function decodePlaytesterIds(p)
	local result = {}
	local playtesters

	if type(p) == "table" then
		playtesters = p.playtesters
	end

	if type(playtesters) ~= "table" then
		return result
	end

	for _, playtester in playtesters do
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

local PlaytestersRequests = {}

function PlaytestersRequests.fetchPlaytesters(p: number, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = playtestersUrl(v.baseUrl or UrlBase.new("develop"), p), -- inferred equivalent call
		analyticsKey = "private-playtesters.fetch",
		legacy = true,
		decode = decodePlaytesterIds
	})))
end

function PlaytestersRequests.addPlaytester(p: number, playtesters, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = playtestersUrl(v, p), -- inferred equivalent call
		body = { playtesters = playtesters },
		analyticsKey = "private-playtesters.add",
		legacy = true,
		decode = decodePlaytesterIds
	})))
end

function PlaytestersRequests.removePlaytester(p: number, p2: number, options)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "DELETE",
		url = playtestersUrl(v, p), -- inferred equivalent call
		body = {
			playtesters = { p2 }
		},
		analyticsKey = "private-playtesters.remove",
		legacy = true,
		decode = decodePlaytesterIds
	})))
end

return PlaytestersRequests
