local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.AssetUserAuthStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function assetUrl(s1: string, s2: string) -- line: 19
	return ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(s1, s2)
end
local function operationUrl(s3: string, s4: string) -- line: 23
	return ("%s/assets/user-auth/v1/operations/%s"):format(s3, s4)
end
local function resolveBase(t1: {[any]: any}?) -- line: 27
	-- upvalues: UrlBase (copy)
	local v17 = t1 or {}

	return v17.network, v17.baseUrl or UrlBase.APIS
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 32
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	patchAssetIcon = function(s5: string, p1, t3: {[any]: any}?) -- line: 39
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v22 = t3 or {}
		local _ = v22.network
		local v24 = v22.baseUrl or UrlBase.APIS
		local v25 = fetch({
			method = "PATCH",
			analyticsKey = "asset-user-auth.patch-icon",
			network = (t3 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(v24, s5),
			body = p1,
			decode = function(p2) -- line: 51
				return p2
			end
		})

		return asPromise(v25)
	end,
	fetchOperation = function(s6: string, t4: {[any]: any}?) -- line: 58
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v28 = t4 or {}
		local network = v28.network
		local v30 = v28.baseUrl or UrlBase.APIS
		local v31 = fetch({
			method = "GET",
			analyticsKey = "asset-user-auth.get-operation",
			network = network,
			url = ("%s/assets/user-auth/v1/operations/%s"):format(v30, s6),
			decode = function(p3) -- line: 65
				return p3
			end
		})

		return asPromise(v31)
	end
}
