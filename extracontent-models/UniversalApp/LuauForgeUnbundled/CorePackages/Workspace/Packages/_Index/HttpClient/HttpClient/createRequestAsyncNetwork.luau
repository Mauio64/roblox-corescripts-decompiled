local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

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

local function createRequestAsyncNetwork()
	return {
		request = function(data, callback)
			assert(
				data.onMessage == nil,
				"createRequestAsyncNetwork does not support onMessage; use createRequestInternalNetwork"
			)

			local flag = false

			task.spawn(function()
				local success, result = pcall(function()
					return HttpService:RequestAsync({
						Url = data.url,
						Method = data.method,
						Headers = data.headers,
						Body = data.body
					})
				end)

				if flag then
					return
				end

				flag = true

				if success then
					callback(true, {
						statusCode = tonumber(result.StatusCode) or 0,
						responseBody = result.Body,
						headers = toLowerKeyedHeaders(result.Headers)
					})
				else
					callback(false, (tostring(result)))
				end
			end)

			return function()
				flag = true
			end
		end
	}
end

return createRequestAsyncNetwork
