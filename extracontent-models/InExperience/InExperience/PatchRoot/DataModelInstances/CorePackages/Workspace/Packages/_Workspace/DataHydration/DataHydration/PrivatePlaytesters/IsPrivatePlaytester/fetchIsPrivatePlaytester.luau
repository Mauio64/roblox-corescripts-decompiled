local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.IsPrivatePlaytesterStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function isPrivatePlaytesterUrl(baseUrl: string, p: number) -- 1 equivalent call inferred from this helper
	return ("%s/universes/v1/universes/%d/is-private-playtester"):format(baseUrl, p)
end

local function fetchIsPrivatePlaytester(p: number, options)
	local v = options or {}
	local baseUrl = v.baseUrl or UrlBase.APIS

	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = isPrivatePlaytesterUrl(baseUrl, p), -- inferred equivalent call
		analyticsKey = "universe-private-playtester.get",
		decode = function(p2)
			return p2
		end
	})))
end

return fetchIsPrivatePlaytester
