require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local createRequest = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/createRequest")
local createRequestInternalNetwork = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/createRequestInternalNetwork")
local withRetry = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/withRetry")
local decoders = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/decoders")
local encoders = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/encoders")
local isSuccess = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/httpStatus").isSuccess
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/statusCodeActions")
local FFlagHttpClientRetryExtensions = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/Flags/FFlagHttpClientRetryExtensions")

local v5 = nil

local function defaultNetwork()
	if v5 == nil then
		v5 = withRetry(createRequestInternalNetwork())
	end

	return v5
end

local function pickNetwork(p2)
	local network = p2.network

	if typeof(p2.retry) == "table" then
		return withRetry(network or createRequestInternalNetwork(), p2.retry)
	end

	if network ~= nil then
		return network
	end

	if p2.retry == false then
		return createRequestInternalNetwork()
	end

	if v5 == nil then
		v5 = withRetry(createRequestInternalNetwork())
	end

	return v5
end

local function asBuffer(responseBody)
	if typeof(responseBody) == "buffer" then
		return responseBody
	end

	return buffer.fromstring(responseBody or "")
end

local function buildProtobufDecoder(callback)
	return function(p2)
		if isSuccess(p2.statusCode) then
			return callback(asBuffer(p2.responseBody)), nil, nil
		end

		return nil, `http {p2.statusCode}`, p2.statusCode
	end
end

local function resolveStatusCodeActions(items)
	local result = module6.snapshot()

	if result == nil then
		return items
	end

	if items ~= nil then
		for k, item in items do
			result[k] = item
		end
	end

	return result
end

local function fetch(data)
	local requestEncoding = data.requestEncoding or "json"
	local responseEncoding = data.responseEncoding or "json"

	local v6 = if requestEncoding == "protobuf" then encoders.encodeRaw("application/x-protobuf") else nil
	local v7

	if responseEncoding == "protobuf" then
		local decode = data.decode

		v7 = function(p2)
			if isSuccess(p2.statusCode) then
				return decode(asBuffer(p2.responseBody)), nil, nil
			end

			return nil, `http {p2.statusCode}`, p2.statusCode
		end
	elseif data.legacy then
		v7 = decoders.decodeLegacyJson(data.decode)
	else
		v7 = decoders.decodeJson(data.decode)
	end

	local v10 = data.network

	if typeof(data.retry) == "table" then
		v10 = withRetry(v10 or createRequestInternalNetwork(), data.retry)
	elseif v10 == nil then
		if data.retry == false then
			v10 = createRequestInternalNetwork()
		else
			if v5 == nil then
				v5 = withRetry(createRequestInternalNetwork())
			end

			v10 = v5
		end
	end

	local v9 = {
		networkImpl = v10,
		method = data.method,
		url = data.url,
		body = data.body,
		headers = data.headers,
		encode = v6,
		decode = v7,
		analyticsKey = data.analyticsKey,
		analytics = data.analytics,
		statusCodeActions = 0,
		onMessage = 0,
		priority = 0
	}
	local statusCodeActions = data.statusCodeActions
	local statusCodeActions2 = module6.snapshot()

	if statusCodeActions2 == nil then
		statusCodeActions2 = statusCodeActions
	elseif statusCodeActions ~= nil then
		for k, statusCodeAction in statusCodeActions do
			statusCodeActions2[k] = statusCodeAction
		end
	end

	v9.statusCodeActions = statusCodeActions2
	local v11 = if FFlagHttpClientRetryExtensions then data.onMessage else nil
	v9.onMessage = v11
	local v12 = if FFlagHttpClientRetryExtensions then data.priority else nil
	v9.priority = v12
	return createRequest(v9)
end

return fetch
