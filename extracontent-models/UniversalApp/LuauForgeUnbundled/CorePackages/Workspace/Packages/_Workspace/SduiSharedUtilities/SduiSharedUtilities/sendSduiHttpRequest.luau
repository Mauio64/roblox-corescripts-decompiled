local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Promise")
local buildSduiRequestHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/buildSduiRequestHeaders")
local FFlagSduiMrRouterHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/Flags/FFlagSduiMrRouterHeaders")

local function deadlineRejection(p2)
	return {
		stats = {},
		statusMessage = `SDUI request exceeded its {p2}s deadline`
	}
end

local function sendSduiHttpRequest(data)
	local network = data.network
		or HttpClient.createRequestInternalNetwork({ transportFailuresAsResponses = true })

	if data.retry then
		network = HttpClient.withRetry(network, data.retry)
	end

	local deadlineSec = data.deadlineSec
	local flag = false
	local delivery = data.delivery
	local onMessage = if delivery.mode == "streaming" then delivery.onMessage else nil

	local fn = onMessage ~= nil and deadlineSec ~= nil and function(p2)
		flag = true
		onMessage(p2)
	end or onMessage

	local createRequest = HttpClient.createRequest
	local v5 = {
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

	local v6 = if FFlagSduiMrRouterHeaders then buildSduiRequestHeaders(data.accept, nil) else { Accept = data.accept }
	v5.headers = v6

	v5.encode = HttpClient.encodeRaw(data.contentType or "application/json")
	function v5.decode(data2)
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

	v5.analyticsKey = data.analyticsKey
	v5.onMessage = fn
	v5.priority = data.priority
	local request = createRequest(v5)

	local v7 = HttpClient.asPromise(request):catch(function(p2)
		return Promise.reject(p2.response or {
			stats = {},
			statusMessage = p2.errorMessage
		})
	end)

	if deadlineSec == nil then
		return v7
	end

	if delivery.mode ~= "streaming" then
		return v7:timeout(deadlineSec, {
			stats = {},
			statusMessage = `SDUI request exceeded its {deadlineSec}s deadline`
		})
	end

	local v8 = {
		Promise.delay(deadlineSec):andThen(function()
			if flag then
				return v7
			end

			return (Promise.reject({
				stats = {},
				statusMessage = `SDUI request exceeded its {deadlineSec}s deadline`
			}))
		end),
		v7
	}
	return Promise.race(v8)
end

return sendSduiHttpRequest
