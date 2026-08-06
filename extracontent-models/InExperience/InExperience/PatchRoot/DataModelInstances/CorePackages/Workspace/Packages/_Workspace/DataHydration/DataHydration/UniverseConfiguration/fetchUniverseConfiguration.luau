local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.UniverseConfigurationStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function summaryUrl(s1: string, n1: number) -- line: 16
	return ("%s/v1/universes/%d"):format(s1, n1)
end
local function configurationUrl(s2: string, n2: number) -- line: 20
	return ("%s/v1/universes/%d/configuration"):format(s2, n2)
end
local function patchConfigurationUrl(s3: string, n3: number) -- line: 24
	return ("%s/v2/universes/%d/configuration"):format(s3, n3)
end
local function teamCreateUrl(s4: string, n4: number) -- line: 28
	return ("%s/v1/universes/%d/teamcreate"):format(s4, n4)
end
local function resolveBase(t1: {[any]: any}?) -- line: 34
	-- upvalues: UrlBase (copy)
	local v23 = t1 or {}

	return v23.network, v23.baseUrl or UrlBase.new("develop")
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 40
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	fetchSummary = function(n5: number, t3: {[any]: any}?) -- line: 47
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v27 = t3 or {}
		local network = v27.network
		local v29 = v27.baseUrl or UrlBase.new("develop")
		local v30 = fetch({
			method = "GET",
			analyticsKey = "universe-configuration.get-summary",
			legacy = true,
			network = network,
			url = ("%s/v1/universes/%d"):format(v29, n5),
			decode = function(p1) -- line: 58
				return p1
			end
		})

		return asPromise(v30)
	end,
	fetchConfiguration = function(n6: number, t4: {[any]: any}?) -- line: 65
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v33 = t4 or {}
		local network = v33.network
		local v35 = v33.baseUrl or UrlBase.new("develop")
		local v36 = fetch({
			method = "GET",
			analyticsKey = "universe-configuration.get-configuration",
			legacy = true,
			network = network,
			url = ("%s/v1/universes/%d/configuration"):format(v35, n6),
			decode = function(p2) -- line: 76
				return p2
			end
		})

		return asPromise(v36)
	end,
	patchConfiguration = function(n7: number, p3, t5: {[any]: any}?) -- line: 83
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v40 = t5 or {}
		local _ = v40.network
		local v42 = v40.baseUrl or UrlBase.new("develop")
		local v43 = fetch({
			method = "PATCH",
			analyticsKey = "universe-configuration.patch-configuration",
			legacy = true,
			network = (t5 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v2/universes/%d/configuration"):format(v42, n7),
			body = p3,
			decode = function(p4) -- line: 96
				if p4.studioAccessToApisAllowed ~= nil then
					p4.isStudioAccessToApisAllowed = p4.studioAccessToApisAllowed
				end

				return p4
			end
		})

		return asPromise(v43)
	end,
	fetchTeamCreate = function(n8: number, t6: {[any]: any}?) -- line: 107
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v46 = t6 or {}
		local network = v46.network
		local v48 = v46.baseUrl or UrlBase.new("develop")
		local v49 = fetch({
			method = "GET",
			analyticsKey = "universe-configuration.get-team-create",
			legacy = true,
			network = network,
			url = ("%s/v1/universes/%d/teamcreate"):format(v48, n8),
			decode = function(p5) -- line: 118
				return p5
			end
		})

		return asPromise(v49)
	end,
	setTeamCreate = function(n9: number, b1: boolean, t7: {[any]: any}?) -- line: 125
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v53 = t7 or {}
		local _ = v53.network
		local v55 = v53.baseUrl or UrlBase.new("develop")
		local v56 = fetch({
			method = "PATCH",
			analyticsKey = "universe-configuration.set-team-create",
			legacy = true,
			network = (t7 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/v1/universes/%d/teamcreate"):format(v55, n9),
			body = {
				isEnabled = b1
			},
			decode = function(_) -- line: 139
				-- upvalues: b1 (copy)
				return {
					isEnabled = b1
				}
			end
		})

		return asPromise(v56)
	end
}
