local HttpService = game:GetService("HttpService")

local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)

local GiftErrorModel = require(Gifting.Models.GiftErrorModel)
require(Gifting.Types)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local v = { 400, 403, 404, 503 }

local function decodeErrorBody(p)
	local responseBody = p.responseBody

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

	local function captureGiftError(p)
		formatted = GiftErrorModel.format(decodeErrorBody(p), p.statusCode)
	end

	local statusCodeActions = {}

	for _, v2 in v do
		statusCodeActions[v2] = { captureGiftError }
	end

	return asPromise((fetch({
		network = data.network,
		retry = false,
		method = data.method,
		url = data.url,
		body = data.body,
		analyticsKey = data.analyticsKey,
		decode = function(p)
			local decoded, v2 = data.decode(p)

			if decoded == nil then
				error(v2 or "malformed response", 0)
			end

			return decoded
		end,
		statusCodeActions = statusCodeActions
	}))):catch(function(p)
		return Promise.reject(formatted or GiftErrorModel.format({}, p.responseCode, p.errorMessage))
	end)
end

return fetchGifting
