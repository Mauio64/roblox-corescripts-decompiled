local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local FFlagHttpClientMrRouterHeaders = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/Flags/FFlagHttpClientMrRouterHeaders")

local v5 = if FFlagHttpClientMrRouterHeaders then require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/MrRouterHeaders") else nil

local function toLowerKeyedHeaders(headers)
	if typeof(headers) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in headers do
		result[tostring(k):lower()] = tostring(item)
	end

	return result
end

local function createRequestInternalNetwork(p2)
	local v6 = not (p2 == nil) and p2.transportFailuresAsResponses

	return {
		request = function(data, callback)
			local v7 = data.headers

			if FFlagHttpClientMrRouterHeaders then
				v7 = v5.injectMrRouterHeaders(data.headers)
			end

			local internal = HttpService:RequestInternal({
				Url = data.url,
				Method = data.method,
				Headers = v7,
				Body = data.body,
				OnMessage = data.onMessage,
				Priority = data.priority
			})

			local flag = false

			internal:Start(function(p3, value)
				if flag then
					return
				end

				flag = true

				if typeof(value) == "table" and (p3 or v6) then
					local v8

					if typeof(value.Stats) == "table" then
						v8 = {}

						for k, stat in value.Stats do
							if typeof(k) == "string" and typeof(stat) == "number" then
								v8[k] = stat
							elseif k == "WasRequestRetried" and typeof(stat) == "boolean" then
								v8.WasRequestRetried = stat and 1 or 0
							end
						end
					end

					callback(true, {
						statusCode = tonumber(value.StatusCode) or 0,
						responseBody = value.Body,
						headers = toLowerKeyedHeaders(value.Headers),
						httpError = value.HttpError,
						stats = v8,
						wasTransportFailure = if v6 then not p3 else nil
					})
				elseif v6 then
					callback(false, (tostring(value or "RequestInternal failed")))
				else
					callback(false, (tostring(value and value.StatusMessage or "RequestInternal failed")))
				end
			end)

			return function()
				if flag then
					return
				end

				flag = true
				pcall(function()
					internal:Cancel()
				end)
			end
		end
	}
end

return createRequestInternalNetwork
