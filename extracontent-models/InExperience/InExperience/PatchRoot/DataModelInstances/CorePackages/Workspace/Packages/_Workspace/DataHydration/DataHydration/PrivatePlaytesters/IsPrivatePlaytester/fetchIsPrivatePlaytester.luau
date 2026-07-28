local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local UrlBase = require(Parent.UrlBuilder).UrlBase

require(script.Parent.IsPrivatePlaytesterStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function isPrivatePlaytesterUrl(s1: string, n1: number) -- line: 15
	return ("%s/universes/v1/universes/%d/is-private-playtester"):format(s1, n1)
end
local function fetchIsPrivatePlaytester(n2: number, t1: {[any]: any}?) -- line: 21
	-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
	local v12 = t1 or {}
	local v13 = v12.baseUrl or UrlBase.APIS
	local v14 = fetch({
		method = "GET",
		analyticsKey = "universe-private-playtester.get",
		network = v12.network,
		url = ("%s/universes/v1/universes/%d/is-private-playtester"):format(v13, n2),
		decode = function(p1) -- line: 33
			return p1
		end
	})

	return asPromise(v14)
end

return fetchIsPrivatePlaytester
