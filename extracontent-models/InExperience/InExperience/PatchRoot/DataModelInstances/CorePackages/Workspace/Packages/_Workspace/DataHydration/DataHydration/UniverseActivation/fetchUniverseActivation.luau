local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.UniverseActivationStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function eligibilityUrl(s1: string, n1: number) -- line: 18
	return ("%s/v1/universes/%d/activation-eligibility"):format(s1, n1)
end
local function activateUrl(s2: string, n2: number) -- line: 22
	return ("%s/v1/universes/%d/activate"):format(s2, n2)
end
local function deactivateUrl(s3: string, n3: number) -- line: 26
	return ("%s/v1/universes/%d/deactivate"):format(s3, n3)
end
local function v2ConfigurationUrl(s4: string, n4: number) -- line: 30
	return ("%s/v2/universes/%d/configuration"):format(s4, n4)
end
local function resolveBase(t1: {[any]: any}?) -- line: 34
	-- upvalues: UrlBase (copy)
	local v23 = t1 or {}

	return v23.network, v23.baseUrl or UrlBase.new("develop")
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 39
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	fetchEligibility = function(n5: number, t3: {[any]: any}?) -- line: 46
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v27 = t3 or {}
		local network = v27.network
		local v29 = v27.baseUrl or UrlBase.new("develop")
		local v30 = fetch({
			method = "GET",
			analyticsKey = "universe-activation.get-eligibility",
			legacy = true,
			network = network,
			url = ("%s/v1/universes/%d/activation-eligibility"):format(v29, n5),
			decode = function(p1) -- line: 57
				return p1
			end
		})

		return asPromise(v30)
	end,
	activate = function(n6: number, p2, t4: {[any]: any}?) -- line: 64
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v34 = t4 or {}
		local _ = v34.network
		local v36 = v34.baseUrl or UrlBase.new("develop")
		local t5 = {}

		if p2 and p2.versionId ~= nil then
			t5.versionId = p2.versionId
		end

		local v38 = fetch({
			method = "POST",
			analyticsKey = "universe-activation.activate",
			legacy = true,
			network = (t4 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v1/universes/%d/activate"):format(v36, n6),
			body = t5,
			decode = function(_) -- line: 82
				return {
					isActive = true
				}
			end
		})

		return asPromise(v38)
	end,
	deactivate = function(n7: number, t6: {[any]: any}?) -- line: 89
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v41 = t6 or {}
		local _ = v41.network
		local v43 = v41.baseUrl or UrlBase.new("develop")
		local v44 = fetch({
			method = "POST",
			analyticsKey = "universe-activation.deactivate",
			legacy = true,
			network = (t6 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v1/universes/%d/deactivate"):format(v43, n7),
			body = {},
			decode = function(_) -- line: 98
				return {
					isActive = false
				}
			end
		})

		return asPromise(v44)
	end,
	fetchAudiences = function(n8: number, t7: {[any]: any}?) -- line: 105
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v47 = t7 or {}
		local network = v47.network
		local v49 = v47.baseUrl or UrlBase.new("develop")
		local v50 = fetch({
			method = "GET",
			analyticsKey = "universe-activation.get-audiences",
			legacy = true,
			network = network,
			url = ("%s/v2/universes/%d/configuration"):format(v49, n8),
			decode = function(p5) -- line: 116
				return p5
			end
		})

		return asPromise(v50)
	end,
	setAudiences = function(n9: number, t8: {[any]: any}, t9: {[any]: any}?) -- line: 123
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v54 = t9 or {}
		local _ = v54.network
		local v56 = v54.baseUrl or UrlBase.new("develop")
		local v57 = fetch({
			method = "PATCH",
			analyticsKey = "universe-activation.set-audiences",
			legacy = true,
			network = (t9 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v2/universes/%d/configuration"):format(v56, n9),
			body = {
				audiences = t8
			},
			decode = function(p6) -- line: 136
				-- upvalues: n9 (copy), t8 (copy)
				if p6 and typeof(p6) == "table" and p6.audiences ~= nil then
					return p6
				end

				return {
					id = n9,
					audiences = t8
				}
			end
		})

		return asPromise(v57)
	end
}
