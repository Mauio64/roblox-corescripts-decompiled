local HttpService = game:GetService("HttpService")

require(script.Parent.types)
local FFlagHttpClientMrRouterHeaders = require(script.Parent.Flags.FFlagHttpClientMrRouterHeaders)
local FFlagHttpClientRetryExtensions = require(script.Parent.Flags.FFlagHttpClientRetryExtensions)
local MrRouterHeaders

if FFlagHttpClientMrRouterHeaders then
	local parent = script:FindFirstAncestor("HttpClient").Parent
	MrRouterHeaders = require(parent.MrRouterHeaders)
else
	MrRouterHeaders = nil
end

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

local function createRequestInternalNetwork(p)
	local v

	if FFlagHttpClientRetryExtensions then
		v = not (p == nil) and p.transportFailuresAsResponses
	else
		v = nil
	end

	return {
		request = function(data, callback)
			local headers = data.headers

			if FFlagHttpClientMrRouterHeaders then
				headers = MrRouterHeaders.injectMrRouterHeaders(data.headers)
			end

			local v2 = {
				Url = data.url,
				Method = data.method,
				Headers = headers,
				Body = data.body,
				OnMessage = data.onMessage,
				Priority = 0
			}
			local priority

			if FFlagHttpClientRetryExtensions then
				priority = data.priority
			end

			v2.Priority = priority
			local internal = HttpService:RequestInternal(v2)

			local flag = false

			internal:Start(function(flag2: boolean, value)
				if flag then
					return
				end

				flag = true

				if typeof(value) == "table" and (flag2 or FFlagHttpClientRetryExtensions and v) then
					local stats

					if typeof(value.Stats) == "table" then
						stats = {}

						for k, stat in value.Stats do
							if typeof(k) == "string" and typeof(stat) == "number" then
								stats[k] = stat
							elseif k == "WasRequestRetried" and typeof(stat) == "boolean" then
								stats.WasRequestRetried = stat and 1 or 0
							end
						end
					end

					local v3 = {
						statusCode = tonumber(value.StatusCode) or 0,
						responseBody = value.Body,
						headers = toLowerKeyedHeaders(value.Headers),
						httpError = value.HttpError,
						stats = stats,
						wasTransportFailure = 0
					}
					local wasTransportFailure

					if FFlagHttpClientRetryExtensions and v then
						wasTransportFailure = not flag2
					end

					v3.wasTransportFailure = wasTransportFailure
					callback(true, v3)
				elseif FFlagHttpClientRetryExtensions and v then
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
