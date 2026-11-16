local parent = script:FindFirstAncestor("HttpClient").Parent

local Resources = require(parent.Resources)
local Signals = require(parent.Signals)

require(script.Parent.types)
local encoders = require(script.Parent.encoders)
local analytics = require(script.Parent.analytics)
local FFlagHttpClientRetryExtensions = require(script.Parent.Flags.FFlagHttpClientRetryExtensions)

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

			local function settleResponse(p)
				if flag then
					return
				end

				flag = true
				local v2 = (os.clock() - lastTime) * 1000

				if data.statusCodeActions ~= nil then
					local statusCodeAction = data.statusCodeActions[p.statusCode]

					if statusCodeAction ~= nil then
						for _, callback2 in statusCodeAction do
							local success, result = pcall(callback2, p)

							if not success then
								warn(`[HttpClient] {data.analyticsKey} status code action threw: {tostring(result)}`)
							end
						end
					end
				end

				local decode = data.decode
				local success, result, err, errorCode = pcall(decode, p)

				if not success then
					err = `decode error: {tostring(result)}`
					result = nil
					errorCode = nil
				end

				local v3 = err == nil and "succeeded" or "failed"
				local response

				if FFlagHttpClientRetryExtensions then
					response = p
				end

				if err == nil then
					v({ status = "succeeded", result = result, response = response })
				else
					v({ status = "failed", error = err, errorCode = errorCode, response = response })
				end

				analytics2(data.analyticsKey, data.method, data.url, p, v2, v3)
			end

			local success, result = pcall(function()
				local request = data.networkImpl.request
				local v2 = {
					url = data.url,
					method = data.method,
					headers = headers,
					body = body,
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
				local v3 = request(v2, function(p, p2)
					if p then
						settleResponse(p2)
					else
						settleFailed(tostring(p2))
					end
				end)
				callback(function()
					if flag then
						return
					end

					flag = true
					v3()
				end)
			end)

			if not success then
				settleFailed(tostring(result))
			end
		end)
	}
end

return createRequest
