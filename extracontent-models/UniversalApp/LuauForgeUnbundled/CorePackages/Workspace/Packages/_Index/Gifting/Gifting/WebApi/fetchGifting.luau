local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Promise")

local GiftErrorModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftErrorModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local v5 = { 400, 403, 404, 503 }

local function decodeErrorBody(p2)
	local responseBody = p2.responseBody

	if typeof(responseBody) == "buffer" then
		responseBody = buffer.tostring(responseBody)
	end

	if responseBody == nil or responseBody == "" then
		return {}
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, responseBody)

	if success and type(result) == "table" then
		return result
	end

	return {}
end

local function fetchGifting(data)
	local formatted = nil

	local function captureGiftError(p2)
		formatted = GiftErrorModel.format(decodeErrorBody(p2), p2.statusCode)
	end

	local v6 = {}

	for k, v7 in v5 do
		v6[v7] = { captureGiftError }
	end

	return asPromise((fetch({
		network = data.network,
		retry = false,
		method = data.method,
		url = data.url,
		body = data.body,
		analyticsKey = data.analyticsKey,
		decode = function(p2)
			local decoded, v7 = data.decode(p2)

			if decoded == nil then
				error(v7 or "malformed response", 0)
			end

			return decoded
		end,
		statusCodeActions = v6
	}))):catch(function(p2)
		return Promise.reject(formatted or GiftErrorModel.format({}, p2.responseCode, p2.errorMessage))
	end)
end

return fetchGifting
