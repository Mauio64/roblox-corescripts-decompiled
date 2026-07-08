require(script.Parent.types)

local createRequest = require(script.Parent.createRequest)
local createRequestInternalNetwork = require(script.Parent.createRequestInternalNetwork)
local withRetry = require(script.Parent.withRetry)
local decoders = require(script.Parent.decoders)
local encoders = require(script.Parent.encoders)
local isSuccess = require(script.Parent.httpStatus).isSuccess
local statusCodeActions = require(script.Parent.statusCodeActions)
local u8 = nil

local function defaultNetwork() -- line: 16
	-- upvalues: u8 (ref), withRetry (copy), createRequestInternalNetwork (copy)
	if u8 == nil then
		u8 = withRetry(createRequestInternalNetwork())
	end

	return u8
end
local function pickNetwork(p1) -- line: 23
	-- upvalues: withRetry (copy), createRequestInternalNetwork (copy), u8 (ref)
	local network = p1.network

	if typeof(p1.retry) == "table" then
		return withRetry(network or createRequestInternalNetwork(), p1.retry)
	end

	if network ~= nil then
		return network
	end

	if p1.retry == false then
		return createRequestInternalNetwork()
	end

	if u8 == nil then
		u8 = withRetry(createRequestInternalNetwork())
	end

	return u8
end
local function asBuffer(p2) -- line: 38
	if typeof(p2) == "buffer" then
		return p2
	end

	return buffer.fromstring(p2 or "")
end
local function buildProtobufDecoder(p3: ((...any) -> ...any)) -- line: 45
	-- upvalues: isSuccess (copy), asBuffer (copy)
	return function(p4) -- line: 46
		-- upvalues: isSuccess (copy), p3 (copy), asBuffer (copy)
		if not isSuccess(p4.statusCode) then
			return nil, `http { p4.statusCode }`, p4.statusCode
		end

		return p3(asBuffer(p4.responseBody)), nil, nil
	end
end
local function resolveStatusCodeActions(p5) -- line: 55
	-- upvalues: statusCodeActions (copy)
	local v20 = statusCodeActions.snapshot()

	if v20 == nil then
		return p5
	end

	if p5 ~= nil then
		for v21, v22 in p5 do
			v20[v21] = v22
		end
	end

	return v20
end
local function fetch(p6) -- line: 68
	-- upvalues: encoders (copy), isSuccess (copy), asBuffer (copy), decoders (copy), createRequest (copy), withRetry (copy), createRequestInternalNetwork (copy), u8 (ref), statusCodeActions (copy)
	local v24 = p6.requestEncoding or "json"
	local v25 = p6.responseEncoding or "json"
	local v26 = nil

	if v24 == "protobuf" then
		v26 = encoders.encodeRaw("application/x-protobuf")
	end

	local v28

	if v25 == "protobuf" then
		local decode = p6.decode

		function v28(p7) -- line: 46
			-- upvalues: isSuccess (copy), decode (copy), asBuffer (copy)
			if not isSuccess(p7.statusCode) then
				return nil, `http { p7.statusCode }`, p7.statusCode
			end

			return decode(asBuffer(p7.responseBody)), nil, nil
		end
	else
		v28 = if not p6.legacy then decoders.decodeJson(p6.decode) else decoders.decodeLegacyJson(p6.decode)
	end

	local v29 = createRequest
	local t1 = {}
	local network = p6.network

	if typeof(p6.retry) == "table" then
		network = withRetry(network or createRequestInternalNetwork(), p6.retry)
	elseif network ~= nil then
	elseif p6.retry == false then
		network = createRequestInternalNetwork()
	else
		if u8 == nil then
			u8 = withRetry(createRequestInternalNetwork())
		end

		network = u8
	end

	t1.networkImpl = network
	t1.method = p6.method
	t1.url = p6.url
	t1.body = p6.body
	t1.headers = p6.headers
	t1.encode = v26
	t1.decode = v28
	t1.analyticsKey = p6.analyticsKey
	t1.analytics = p6.analytics

	local statusCodeActions2 = p6.statusCodeActions
	local v33 = statusCodeActions.snapshot()

	if v33 == nil then
	else
		if statusCodeActions2 ~= nil then
			for v34, v35 in statusCodeActions2 do
				v33[v34] = v35
			end
		end

		statusCodeActions2 = v33
	end

	t1.statusCodeActions = statusCodeActions2

	return v29(t1)
end

return fetch
