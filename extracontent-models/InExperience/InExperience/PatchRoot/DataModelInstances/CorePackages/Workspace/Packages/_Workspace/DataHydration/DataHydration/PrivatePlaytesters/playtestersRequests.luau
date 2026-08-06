local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function playtestersUrl(s1: string, n1: number) -- line: 29
	return ("%s/v1/universes/%d/configuration/playtesters"):format(s1, n1)
end
local function resolveBase(t1: {[any]: any}?) -- line: 33
	-- upvalues: UrlBase (copy)
	local v15 = t1 or {}

	return v15.network, v15.baseUrl or UrlBase.new("develop")
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 39
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end
local function decodePlaytesterIds(p1) -- line: 46
	local t3 = {}
	local v19 = if type(p1) ~= "table" then nil else p1.playtesters

	if type(v19) == "table" then
		for _, v21 in v19 do
			if type(v21) == "number" then
				table.insert(t3, v21)
			elseif type(v21) == "table" then
				local v22 = v21.userId or v21.id

				if type(v22) == "number" then
					table.insert(t3, v22)
				end
			end
		end
	end

	return t3
end

return {
	fetchPlaytesters = function(n2: number, t4: {[any]: any}?) -- line: 66
		-- upvalues: UrlBase (copy), fetch (copy), decodePlaytesterIds (copy), asPromise (copy)
		local v25 = t4 or {}
		local network = v25.network
		local v27 = v25.baseUrl or UrlBase.new("develop")
		local v28 = fetch({
			method = "GET",
			analyticsKey = "private-playtesters.fetch",
			legacy = true,
			network = network,
			url = ("%s/v1/universes/%d/configuration/playtesters"):format(v27, n2),
			decode = decodePlaytesterIds
		})

		return asPromise(v28)
	end,
	addPlaytester = function(n3: number, t5: {[any]: any}, t6: {[any]: any}?) -- line: 79
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), decodePlaytesterIds (copy), asPromise (copy)
		local v32 = t6 or {}
		local _ = v32.network
		local v34 = v32.baseUrl or UrlBase.new("develop")
		local v35 = fetch({
			method = "POST",
			analyticsKey = "private-playtesters.add",
			legacy = true,
			network = (t6 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v1/universes/%d/configuration/playtesters"):format(v34, n3),
			body = {
				playtesters = t5
			},
			decode = decodePlaytesterIds
		})

		return asPromise(v35)
	end,
	removePlaytester = function(n4: number, n5: number, t7: {[any]: any}?) -- line: 97
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), decodePlaytesterIds (copy), asPromise (copy)
		local v39 = t7 or {}
		local _ = v39.network
		local v41 = v39.baseUrl or UrlBase.new("develop")
		local v42 = fetch({
			method = "DELETE",
			analyticsKey = "private-playtesters.remove",
			legacy = true,
			network = (t7 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v1/universes/%d/configuration/playtesters"):format(v41, n4),
			body = {
				playtesters = { n5 }
			},
			decode = decodePlaytesterIds
		})

		return asPromise(v42)
	end
}
