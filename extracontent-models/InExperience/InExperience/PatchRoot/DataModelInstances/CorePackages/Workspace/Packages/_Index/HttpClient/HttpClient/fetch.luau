require(script.Parent.types)
local createRequest = require(script.Parent.createRequest)
local createRequestInternalNetwork = require(script.Parent.createRequestInternalNetwork)
local withRetry = require(script.Parent.withRetry)
local decoders = require(script.Parent.decoders)
local encoders = require(script.Parent.encoders)
local httpStatus = require(script.Parent.httpStatus)
local isSuccess = httpStatus.isSuccess
local statusCodeActions = require(script.Parent.statusCodeActions)
local FFlagHttpClientRetryExtensions = require(script.Parent.Flags.FFlagHttpClientRetryExtensions)

local v = nil

local function defaultNetwork() -- 1 equivalent call inferred from this helper
	if v == nil then
		v = withRetry(createRequestInternalNetwork())
	end

	return v
end

local function pickNetwork(data) -- 1 equivalent call inferred from this helper
	local network = data.network

	if typeof(data.retry) == "table" then
		return withRetry(network or createRequestInternalNetwork(), data.retry)
	end

	if network ~= nil then
		return network
	end

	if data.retry == false then
		return createRequestInternalNetwork()
	end

	return defaultNetwork() -- inferred equivalent call
end

local function asBuffer(responseBody)
	if typeof(responseBody) == "buffer" then
		return responseBody
	end

	return buffer.fromstring(responseBody or "")
end

local function buildProtobufDecoder(decode) -- 1 equivalent call inferred from this helper
	return function(p)
		if isSuccess(p.statusCode) then
			return decode(asBuffer(p.responseBody)), nil, nil
		end

		return nil, `http {p.statusCode}`, p.statusCode
	end
end

local function resolveStatusCodeActions(statusCodeActions2) -- 1 equivalent call inferred from this helper
	local result = statusCodeActions.snapshot()

	if result == nil then
		return statusCodeActions2
	end

	if statusCodeActions2 ~= nil then
		for k, item in statusCodeActions2 do
			result[k] = item
		end
	end

	return result
end

local function fetch(data)
	local requestEncoding = data.requestEncoding or "json"
	local responseEncoding = data.responseEncoding or "json"
	local encode

	if requestEncoding == "protobuf" then
		encode = encoders.encodeRaw("application/x-protobuf")
	end

	local decode

	if responseEncoding == "protobuf" then
		decode = buildProtobufDecoder(data.decode) -- inferred equivalent call
	elseif data.legacy then
		decode = decoders.decodeLegacyJson(data.decode)
	else
		decode = decoders.decodeJson(data.decode)
	end

	local v2 = {
		networkImpl = pickNetwork(data), -- inferred equivalent call
		method = data.method,
		url = data.url,
		body = data.body,
		headers = data.headers,
		encode = encode,
		decode = decode,
		analyticsKey = data.analyticsKey,
		analytics = data.analytics,
		statusCodeActions = resolveStatusCodeActions(data.statusCodeActions), -- inferred equivalent call
		onMessage = 0,
		priority = 0
	}
	local onMessage

	if FFlagHttpClientRetryExtensions then
		onMessage = data.onMessage
	end

	v2.onMessage = onMessage
	local priority

	if FFlagHttpClientRetryExtensions then
		priority = data.priority
	end

	v2.priority = priority
	return createRequest(v2)
end

return fetch
