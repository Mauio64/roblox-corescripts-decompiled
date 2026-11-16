local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.AssetUserAuthStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(options)
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.APIS
end

local function resolveMutatingNetwork(options) -- 4 equivalent calls inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function buildMultipartBody(p: string, p2: string?, value: string?) -- 1 equivalent call inferred from this helper
	local v = "---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. p .. "\r\n"

	if p2 then
		v = ((((v .. "---------PublishServiceCreateAsset\r\n") .. "Content-Disposition: form-data; name=\"fileContent\"; filename=\"contentToUpload\"\r\n") .. "Content-Type: " .. (value or "application/octet-stream") .. "\r\n") .. "\r\n") .. p2 .. "\r\n"
	end

	return v .. "---------PublishServiceCreateAsset--\r\n"
end

local createRequest = HttpClient.createRequest
local encodeRaw = HttpClient.encodeRaw
local decodeJson = HttpClient.decodeJson

local function multipartRequest(networkImpl, method: string, formatted: string, body: string, analyticsKey: string)
	return asPromise((createRequest({
		networkImpl = networkImpl,
		method = method,
		url = formatted,
		body = body,
		headers = {},
		encode = encodeRaw("multipart/form-data; boundary=-------PublishServiceCreateAsset"),
		decode = decodeJson(function(p)
			return p
		end),
		analyticsKey = analyticsKey
	})))
end

local FetchAssetUserAuth = {}

function FetchAssetUserAuth.patchAssetIcon(p: string, body, options)
	local v = options or {}
	local _network = v.network
	local formatted = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(v.baseUrl or UrlBase.APIS, p)
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "PATCH",
		url = formatted,
		body = body,
		analyticsKey = "asset-user-auth.patch-icon",
		decode = function(p2)
			return p2
		end
	})))
end

function FetchAssetUserAuth.updateIcon(p: string, p2: string, options)
	local v = options or {}
	local _network = v.network
	local formatted = ("%s/assets/user-auth/v1/assets/%s?updateMask=icon"):format(v.baseUrl or UrlBase.APIS, p)
	local body = ("---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. HttpService:JSONEncode({
		assetId = tonumber(p),
		icon = `assets/{p2}`
	}) .. "\r\n") .. "---------PublishServiceCreateAsset--\r\n"

	return multipartRequest(resolveMutatingNetwork(options), "PATCH", formatted, body, "asset-user-auth.update-icon") -- inferred equivalent call
end

function FetchAssetUserAuth.getPreviews(p: string, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = ("%s/assets/user-auth/v1/assets/%s?readMask=previews"):format(v.baseUrl or UrlBase.APIS, p),
		analyticsKey = "asset-user-auth.get-previews",
		decode = function(p2)
			return p2.previews or {}
		end
	})))
end

function FetchAssetUserAuth.updatePreviews(p: string, previews, options)
	local v = options or {}
	local _network = v.network
	local formatted = ("%s/assets/user-auth/v1/assets/%s?updateMask=previews"):format(v.baseUrl or UrlBase.APIS, p)
	local body = ("---------PublishServiceCreateAsset\r\nContent-Disposition: form-data; name=\"request\"\r\nContent-Type: application/json\r\n\r\n" .. HttpService:JSONEncode({
		assetId = tonumber(p),
		previews = previews
	}) .. "\r\n") .. "---------PublishServiceCreateAsset--\r\n"

	return multipartRequest(
		resolveMutatingNetwork(options), -- inferred equivalent call
		"PATCH",
		formatted,
		body,
		"asset-user-auth.update-previews"
	)
end

function FetchAssetUserAuth.createImageAsset(p: string, value: string, data, options)
	local v = options or {}
	local _network = v.network
	local formatted = ("%s/assets/user-auth/v1/assets"):format(v.baseUrl or UrlBase.APIS)
	local creator

	if data.groupId then
		creator = { groupId = data.groupId }
	else
		creator = {
			userId = data.userId or ""
		}
	end

	local multipartBody = buildMultipartBody(HttpService:JSONEncode({ -- inferred equivalent call
		assetType = "Image",
		displayName = data.displayName or "Game Thumbnail",
		description = data.description or "Game thumbnail from capture",
		creationContext = { creator = creator }
	}), p, value)

	return multipartRequest(
		resolveMutatingNetwork(options), -- inferred equivalent call
		"POST",
		formatted,
		multipartBody,
		"asset-user-auth.create-image-asset"
	)
end

function FetchAssetUserAuth.fetchOperation(p: string, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = ("%s/assets/user-auth/v1/operations/%s"):format(v.baseUrl or UrlBase.APIS, p),
		analyticsKey = "asset-user-auth.get-operation",
		decode = function(p2)
			return p2
		end
	})))
end

return FetchAssetUserAuth
