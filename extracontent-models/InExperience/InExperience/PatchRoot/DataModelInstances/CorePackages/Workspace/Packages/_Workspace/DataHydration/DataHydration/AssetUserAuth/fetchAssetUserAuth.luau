local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.AssetUserAuthStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(t1: {[any]: any}?) -- line: 28
	-- upvalues: UrlBase (copy)
	local v17 = t1 or {}

	return v17.network, v17.baseUrl or UrlBase.APIS
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 33
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end
local function buildMultipartBody(s1: string, s2: string?, s3: string?) -- line: 38
	local v22 = (((("" .. "--" .. "-------PublishServiceCreateAsset" .. "\r\n") .. "Content-Disposition: form-data; name=\"request\"" .. "\r\n") .. "Content-Type: application/json" .. "\r\n") .. "\r\n") .. s1 .. "\r\n"

	if s2 then
		v22 = ((((v22 .. "--" .. "-------PublishServiceCreateAsset" .. "\r\n") .. "Content-Disposition: form-data; name=\"fileContent\"; filename=\"contentToUpload\"" .. "\r\n") .. "Content-Type: " .. (s3 or "application/octet-stream") .. "\r\n") .. "\r\n") .. s2 .. "\r\n"
	end

	return v22 .. "--" .. "-------PublishServiceCreateAsset" .. "--" .. "\r\n"
end

local createRequest = HttpClient.createRequest
local encodeRaw = HttpClient.encodeRaw
local decodeJson = HttpClient.decodeJson

local function multipartRequest(p1, s4: string, s5: string, s6: string, s7: string) -- line: 60
	-- upvalues: createRequest (copy), encodeRaw (copy), decodeJson (copy), asPromise (copy)
	local v28 = createRequest({
		networkImpl = p1,
		method = s4,
		url = s5,
		body = s6,
		headers = {},
		encode = encodeRaw("multipart/form-data; boundary=-------PublishServiceCreateAsset"),
		decode = decodeJson(function(p2) -- line: 74
			return p2
		end),
		analyticsKey = s7
	})

	return asPromise(v28)
end

return {
	patchAssetIcon = function(s8: string, p3, t3: {[any]: any}?) -- line: 84
		-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v32 = t3 or {}
		local _ = v32.network
		local v34 = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(v32.baseUrl or UrlBase.APIS, s8)
		local v35 = fetch({
			method = "PATCH",
			analyticsKey = "asset-user-auth.patch-icon",
			network = (t3 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = v34,
			body = p3,
			decode = function(p4) -- line: 97
				return p4
			end
		})

		return asPromise(v35)
	end,
	updateIcon = function(s9: string, s10: string, t4: {[any]: any}?) -- line: 104
		-- upvalues: UrlBase (copy), HttpService (copy), multipartRequest (copy), withCsrfRetry (copy), HttpClient (copy)
		local v39 = t4 or {}
		local _ = v39.network
		local v41 = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(v39.baseUrl or UrlBase.APIS, s9)
		local json = HttpService:JSONEncode({
			assetId = tonumber(s9),
			icon = `assets/{ s10 }`
		})
		local v43 = ((((("" .. "--" .. "-------PublishServiceCreateAsset" .. "\r\n") .. "Content-Disposition: form-data; name=\"request\"" .. "\r\n") .. "Content-Type: application/json" .. "\r\n") .. "\r\n") .. json .. "\r\n") .. "--" .. "-------PublishServiceCreateAsset" .. "--" .. "\r\n"

		return multipartRequest((t4 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()), "PATCH", v41, v43, "asset-user-auth.update-icon")
	end,
	getPreviews = function(s11: string, t5: {[any]: any}?) -- line: 119
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v46 = t5 or {}
		local network = v46.network
		local v48 = ("%s/assets/user-auth/v1/assets/%s?readMask=previews"):format(v46.baseUrl or UrlBase.APIS, s11)
		local v49 = fetch({
			method = "GET",
			analyticsKey = "asset-user-auth.get-previews",
			network = network,
			url = v48,
			decode = function(p5) -- line: 127
				return p5.previews or {}
			end
		})

		return asPromise(v49)
	end,
	updatePreviews = function(s12: string, t6: {[any]: any}, t7: {[any]: any}?) -- line: 134
		-- upvalues: UrlBase (copy), HttpService (copy), multipartRequest (copy), withCsrfRetry (copy), HttpClient (copy)
		local v53 = t7 or {}
		local _ = v53.network
		local v55 = ("%s/assets/user-auth/v1/assets/%s?updateMask=previews"):format(v53.baseUrl or UrlBase.APIS, s12)
		local json = HttpService:JSONEncode({
			assetId = tonumber(s12),
			previews = t6
		})
		local v57 = ((((("" .. "--" .. "-------PublishServiceCreateAsset" .. "\r\n") .. "Content-Disposition: form-data; name=\"request\"" .. "\r\n") .. "Content-Type: application/json" .. "\r\n") .. "\r\n") .. json .. "\r\n") .. "--" .. "-------PublishServiceCreateAsset" .. "--" .. "\r\n"

		return multipartRequest((t7 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()), "PATCH", v55, v57, "asset-user-auth.update-previews")
	end,
	createImageAsset = function(s13: string, s14: string, p6, t8: {[any]: any}?) -- line: 149
		-- upvalues: UrlBase (copy), HttpService (copy), multipartRequest (copy), withCsrfRetry (copy), HttpClient (copy)
		local v62 = t8 or {}
		local _ = v62.network
		local v64 = ("%s/assets/user-auth/v1/assets"):format(v62.baseUrl or UrlBase.APIS)
		local v65 = if not p6.groupId then {
			userId = p6.userId or ""
		} else {
			groupId = p6.groupId
		}
		local json = HttpService:JSONEncode({
			assetType = "Image",
			displayName = p6.displayName or "Game Thumbnail",
			description = p6.description or "Game thumbnail from capture",
			creationContext = {
				creator = v65
			}
		})
		local v67 = (((("" .. "--" .. "-------PublishServiceCreateAsset" .. "\r\n") .. "Content-Disposition: form-data; name=\"request\"" .. "\r\n") .. "Content-Type: application/json" .. "\r\n") .. "\r\n") .. json .. "\r\n"

		if s13 then
			v67 = ((((v67 .. "--" .. "-------PublishServiceCreateAsset" .. "\r\n") .. "Content-Disposition: form-data; name=\"fileContent\"; filename=\"contentToUpload\"" .. "\r\n") .. "Content-Type: " .. (s14 or "application/octet-stream") .. "\r\n") .. "\r\n") .. s13 .. "\r\n"
		end

		local v68 = v67 .. "--" .. "-------PublishServiceCreateAsset" .. "--" .. "\r\n"

		return multipartRequest((t8 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()), "POST", v64, v68, "asset-user-auth.create-image-asset")
	end,
	fetchOperation = function(s15: string, t9: {[any]: any}?) -- line: 170
		-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
		local v71 = t9 or {}
		local network = v71.network
		local v73 = ("%s/assets/user-auth/v1/operations/%s"):format(v71.baseUrl or UrlBase.APIS, s15)
		local v74 = fetch({
			method = "GET",
			analyticsKey = "asset-user-auth.get-operation",
			network = network,
			url = v73,
			decode = function(p7) -- line: 178
				return p7
			end
		})

		return asPromise(v74)
	end
}
