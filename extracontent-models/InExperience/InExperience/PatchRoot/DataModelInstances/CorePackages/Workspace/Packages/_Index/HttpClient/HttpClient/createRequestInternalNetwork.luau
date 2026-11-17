local HttpService = game:GetService("HttpService")

require(script.Parent.types)
local FFlagHttpClientMrRouterHeaders = require(script.Parent.Flags.FFlagHttpClientMrRouterHeaders)
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

	if p == nil then
		v = false
	else
		v = p.transportFailuresAsResponses
	end

	return {
		request = function(data, callback)
			local headers = data.headers

			if FFlagHttpClientMrRouterHeaders then
				headers = MrRouterHeaders.injectMrRouterHeaders(data.headers)
			end

			local internal = HttpService:RequestInternal({
				Url = data.url,
				Method = data.method,
				Headers = headers,
				Body = data.body,
				OnMessage = data.onMessage,
				Priority = data.priority
			})

			local flag = false

			internal:Start(function(flag2: boolean, value)
				if flag then
					return
				end

				flag = true

				if typeof(value) == "table" and (flag2 or v) then
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

					local v2 = {
						statusCode = tonumber(value.StatusCode) or 0,
						responseBody = value.Body,
						headers = toLowerKeyedHeaders(value.Headers),
						httpError = value.HttpError,
						stats = stats,
						wasTransportFailure = 0
					}
					local wasTransportFailure

					if v then
						wasTransportFailure = not flag2
					end

					v2.wasTransportFailure = wasTransportFailure
					callback(true, v2)
				elseif v then
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
