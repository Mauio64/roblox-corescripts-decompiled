local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local buildSduiRequestHeaders = require(SduiSharedUtilities.buildSduiRequestHeaders)
local FFlagSduiMrRouterHeaders = require(SduiSharedUtilities.Flags.FFlagSduiMrRouterHeaders)

local function deadlineRejection(deadlineSec: number) -- 2 equivalent calls inferred from this helper
	return {
		stats = {},
		statusMessage = `SDUI request exceeded its {deadlineSec}s deadline`
	}
end

local function sendSduiHttpRequest(data)
	local network = data.network or HttpClient.createRequestInternalNetwork({
		transportFailuresAsResponses = true
	})

	if data.retry then
		network = HttpClient.withRetry(network, data.retry)
	end

	local deadlineSec = data.deadlineSec
	local flag = false
	local delivery = data.delivery
	local onMessage

	if delivery.mode == "streaming" then
		onMessage = delivery.onMessage
	else
		onMessage = nil
	end

	local fn = onMessage ~= nil and deadlineSec ~= nil and function(p: string)
		flag = true
		onMessage(p)
	end or onMessage

	local createRequest = HttpClient.createRequest
	local v = {
		networkImpl = network,
		method = data.method,
		url = data.url,
		body = data.body,
		headers = 0,
		encode = 0,
		decode = 0,
		analyticsKey = 0,
		onMessage = 0,
		priority = 0
	}
	local headers

	if FFlagSduiMrRouterHeaders then
		headers = buildSduiRequestHeaders(data.accept, nil)
	else
		headers = { Accept = data.accept }
	end

	v.headers = headers

	v.encode = HttpClient.encodeRaw(data.contentType or "application/json")
	function v.decode(data2)
		if
			data2.statusCode >= 400
			or data2.httpError ~= nil and data2.httpError ~= Enum.HttpError.OK
			or data2.wasTransportFailure == true
		then
			return
				nil,
				`Http request not successful StatusCode {data2.statusCode} HttpError {data2.httpError}`,
				data2.statusCode
		end

		return data2, nil, nil
	end

	v.analyticsKey = data.analyticsKey
	v.onMessage = fn
	v.priority = data.priority
	local request = createRequest(v)

	local v2 = HttpClient.asPromise(request):catch(function(p)
		return Promise.reject(p.response or { stats = {}, statusMessage = p.errorMessage })
	end)

	if deadlineSec == nil then
		return v2
	end

	if delivery.mode ~= "streaming" then
		return v2:timeout(deadlineSec, deadlineRejection(deadlineSec)) -- inferred equivalent call
	end

	local v3 = {
		Promise.delay(deadlineSec):andThen(function()
			if flag then
				return v2
			end

			return (Promise.reject(deadlineRejection(deadlineSec))) -- inferred equivalent call
		end),
		v2
	}
	return Promise.race(v3)
end

return sendSduiHttpRequest
