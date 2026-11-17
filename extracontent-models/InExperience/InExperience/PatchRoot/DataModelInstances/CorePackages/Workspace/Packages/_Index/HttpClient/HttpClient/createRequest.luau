local parent = script:FindFirstAncestor("HttpClient").Parent

local Resources = require(parent.Resources)
local Signals = require(parent.Signals)

require(script.Parent.types)
local encoders = require(script.Parent.encoders)
local analytics = require(script.Parent.analytics)

local createSignal = Signals.createSignal
local createResource = Resources.createResource

local function safeDecode(callback, p)
	local success, result, v, v2 = pcall(callback, p)

	if success then
		return result, v, v2
	end

	return nil, `decode error: {tostring(result)}`, nil
end

local function createRequest(data)
	local analytics2 = data.analytics or analytics.defaultAnalytics
	local encode = data.encode or encoders.encodeJson

	local signal, v = createSignal({ status = "pending" })

	local headers = { Accept = "application/json" }

	if data.headers then
		for k, header in data.headers do
			headers[k] = header
		end
	end

	local body

	if data.body == nil then
		body = nil
	else
		local v2
		body, v2 = encode(data.body)

		headers["Content-Type"] = headers["Content-Type"] or v2
	end

	return {
		state = signal,
		dispose = createResource(function(callback)
			local flag = false
			local lastTime = os.clock()

			local function settleFailed(p: string)
				if flag then
					return
				end

				flag = true
				local v2 = (os.clock() - lastTime) * 1000
				v({ status = "failed", error = `transport error: {p}` })
				analytics2(data.analyticsKey, data.method, data.url, nil, v2, "failed")
			end

			local function settleResponse(response)
				if flag then
					return
				end

				flag = true
				local v2 = (os.clock() - lastTime) * 1000

				if data.statusCodeActions ~= nil then
					local statusCodeAction = data.statusCodeActions[response.statusCode]

					if statusCodeAction ~= nil then
						for _, callback2 in statusCodeAction do
							local success, result = pcall(callback2, response)

							if not success then
								warn(`[HttpClient] {data.analyticsKey} status code action threw: {tostring(result)}`)
							end
						end
					end
				end

				local success, result, err, errorCode = pcall(data.decode, response)

				if not success then
					err = `decode error: {tostring(result)}`
					result = nil
					errorCode = nil
				end

				local v3 = err == nil and "succeeded" or "failed"

				if err == nil then
					v({ status = "succeeded", result = result, response = response })
				else
					v({ status = "failed", error = err, errorCode = errorCode, response = response })
				end

				analytics2(data.analyticsKey, data.method, data.url, response, v2, v3)
			end

			local success, result = pcall(function()
				local request = data.networkImpl.request({
					url = data.url,
					method = data.method,
					headers = headers,
					body = body,
					onMessage = data.onMessage,
					priority = data.priority
				}, function(p, response)
					if p then
						settleResponse(response)
					else
						settleFailed(tostring(response))
					end
				end)
				callback(function()
					if flag then
						return
					end

					flag = true
					request()
				end)
			end)

			if not success then
				settleFailed(tostring(result))
			end
		end)
	}
end

return createRequest
