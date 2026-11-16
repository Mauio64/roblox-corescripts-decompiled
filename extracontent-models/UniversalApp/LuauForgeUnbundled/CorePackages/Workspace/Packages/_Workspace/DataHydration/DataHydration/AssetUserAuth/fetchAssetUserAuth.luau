local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/AssetUserAuthStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(options)
	local v5 = options or {}
	return v5.network, v5.baseUrl or urlBase.APIS
end

local function resolveMutatingNetwork(options)
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function buildMultipartBody(p2, p3, value)
	local v5 = "---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. p2 .. "\r\n"

	if p3 then
		v5 = ((((v5 .. "---------PublishServiceCreateAsset\r\n") .. "Content-Disposition: form-data; name=\"fileContent\"; filename=\"contentToUpload\"\r\n") .. "Content-Type: " .. (value or "application/octet-stream") .. "\r\n") .. "\r\n") .. p3 .. "\r\n"
	end

	return v5 .. "---------PublishServiceCreateAsset--\r\n"
end

local createRequest = HttpClient.createRequest
local encodeRaw = HttpClient.encodeRaw
local decodeJson = HttpClient.decodeJson

local function multipartRequest(network, p2, formatted, p3, p4)
	return asPromise((createRequest({
		networkImpl = network,
		method = p2,
		url = formatted,
		body = p3,
		headers = {},
		encode = encodeRaw("multipart/form-data; boundary=-------PublishServiceCreateAsset"),
		decode = decodeJson(function(p5)
			return p5
		end),
		analyticsKey = p4
	})))
end

return {
	patchAssetIcon = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local formatted = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(
			v5.baseUrl or urlBase.APIS,
			p2
		)
		return asPromise((fetch({
			network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			method = "PATCH",
			url = formatted,
			body = p3,
			analyticsKey = "asset-user-auth.patch-icon",
			decode = function(p4)
				return p4
			end
		})))
	end,
	updateIcon = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local formatted = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(
			v5.baseUrl or urlBase.APIS,
			p2
		)
		local v6 = ("---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. HttpService:JSONEncode({
			assetId = tonumber(p2),
			icon = `assets/{p3}`
		}) .. "\r\n") .. "---------PublishServiceCreateAsset--\r\n"
		return multipartRequest(
			(options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			"PATCH",
			formatted,
			v6,
			"asset-user-auth.update-icon"
		)
	end,
	getPreviews = function(p2, options)
		local v5 = options or {}
		return asPromise((fetch({
			network = v5.network,
			method = "GET",
			url = ("%s/assets/user-auth/v1/assets/%s?readMask=previews"):format(
				v5.baseUrl or urlBase.APIS,
				p2
			),
			analyticsKey = "asset-user-auth.get-previews",
			decode = function(p3)
				return p3.previews or {}
			end
		})))
	end,
	updatePreviews = function(p2, p3, options)
		local v5 = options or {}
		local network = v5.network
		local formatted = ("%s/assets/user-auth/v1/assets/%s?updateMask=previews"):format(
			v5.baseUrl or urlBase.APIS,
			p2
		)
		local v6 = ("---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. HttpService:JSONEncode({
			assetId = tonumber(p2),
			previews = p3
		}) .. "\r\n") .. "---------PublishServiceCreateAsset--\r\n"
		return multipartRequest(
			(options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			"PATCH",
			formatted,
			v6,
			"asset-user-auth.update-previews"
		)
	end,
	createImageAsset = function(p2, value, data, options)
		local v5 = options or {}
		local network = v5.network
		local formatted = ("%s/assets/user-auth/v1/assets"):format(v5.baseUrl or urlBase.APIS)
		local v6

		if data.groupId then
			v6 = { groupId = data.groupId }
		else
			v6 = {
				userId = data.userId or ""
			}
		end

		local v7 = "---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. HttpService:JSONEncode({
			assetType = "Image",
			displayName = data.displayName or "Game Thumbnail",
			description = data.description or "Game thumbnail from capture",
			creationContext = { creator = v6 }
		}) .. "\r\n"

		if p2 then
			v7 = ((((v7 .. "---------PublishServiceCreateAsset\r\n") .. "Content-Disposition: form-data; name=\"fileContent\"; filename=\"contentToUpload\"\r\n") .. "Content-Type: " .. (value or "application/octet-stream") .. "\r\n") .. "\r\n") .. p2 .. "\r\n"
		end

		local v8 = v7 .. "---------PublishServiceCreateAsset--\r\n"
		return multipartRequest(
			(options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			"POST",
			formatted,
			v8,
			"asset-user-auth.create-image-asset"
		)
	end,
	fetchOperation = function(p2, options)
		local v5 = options or {}
		return asPromise((fetch({
			network = v5.network,
			method = "GET",
			url = ("%s/assets/user-auth/v1/operations/%s"):format(v5.baseUrl or urlBase.APIS, p2),
			analyticsKey = "asset-user-auth.get-operation",
			decode = function(p3)
				return p3
			end
		})))
	end
}
