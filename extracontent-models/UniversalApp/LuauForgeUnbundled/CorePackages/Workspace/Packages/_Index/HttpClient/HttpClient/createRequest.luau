local Resources = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/Resources")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local encoders = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/encoders")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/analytics")

local createSignal = Signals.createSignal
local createResource = Resources.createResource

local function safeDecode(callback, p2)
	local success, result, v5, v6 = pcall(callback, p2)

	if success then
		return result, v5, v6
	end

	return nil, `decode error: {tostring(result)}`, nil
end

local function createRequest(data)
	local analytics = data.analytics or module4.defaultAnalytics
	local encode = data.encode or encoders.encodeJson

	local signal, v5 = createSignal({ status = "pending" })

	local headers = { Accept = "application/json" }

	if data.headers then
		for k, header in data.headers do
			headers[k] = header
		end
	end

	local v6

	if data.body == nil then
		v6 = nil
	else
		local v7
		v6, v7 = encode(data.body)

		headers["Content-Type"] = headers["Content-Type"] or v7
	end

	return {
		state = signal,
		dispose = createResource(function(callback)
			local flag = false
			local lastTime = os.clock()

			local function settleFailed(p2)
				if flag then
					return
				end

				flag = true
				local v7 = (os.clock() - lastTime) * 1000
				v5({ status = "failed", error = `transport error: {p2}` })
				analytics(data.analyticsKey, data.method, data.url, nil, v7, "failed")
			end

			local function settleResponse(p2)
				if flag then
					return
				end

				flag = true
				local v7 = (os.clock() - lastTime) * 1000

				if data.statusCodeActions ~= nil then
					local statusCodeAction = data.statusCodeActions[p2.statusCode]

					if statusCodeAction ~= nil then
						for k, callback2 in statusCodeAction do
							local success, result = pcall(callback2, p2)

							if not success then
								warn(`[HttpClient] {data.analyticsKey} status code action threw: {tostring(result)}`)
							end
						end
					end
				end

				local success, result, v8, v9 = pcall(data.decode, p2)

				if not success then
					v8 = `decode error: {tostring(result)}`
					result = nil
					v9 = nil
				end

				local v10 = v8 == nil and "succeeded" or "failed"

				if v8 == nil then
					v5({ status = "succeeded", result = result, response = p2 })
				else
					v5({ status = "failed", error = v8, errorCode = v9, response = p2 })
				end

				analytics(data.analyticsKey, data.method, data.url, p2, v7, v10)
			end

			local success, result = pcall(function()
				local request = data.networkImpl.request({
					url = data.url,
					method = data.method,
					headers = headers,
					body = v6,
					onMessage = data.onMessage,
					priority = data.priority
				}, function(p2, p3)
					if p2 then
						settleResponse(p3)
					else
						settleFailed(tostring(p3))
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
