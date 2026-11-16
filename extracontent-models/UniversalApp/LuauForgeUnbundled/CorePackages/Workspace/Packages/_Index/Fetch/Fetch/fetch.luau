local err = require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill").Error

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/Promise")

local response = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Response").Response

local request = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Request").Request

local function parseResponse(data)
	local body = data.Body

	return response.new(body, {
		status = data.StatusCode,
		statusText = data.StatusMessage,
		headers = data.Headers
	})
end

local function buildFetch(object)
	local function fetch(p2, p3)
		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return request.new(p2, p3)
			end)

			if success then
				object:RequestInternal({
					Url = result.url,
					Method = result.method,
					Body = result.body,
					Headers = result.headers.headerList,
					CachePolicy = result.cache
				}):Start(function(p4, data)
					if p4 then
						local body = data.Body

						callback((response.new(body, {
							status = data.StatusCode,
							statusText = data.StatusMessage,
							headers = data.Headers
						})))
					else
						result.signal:fire()
						callback2(err.new(data.ErrorMessage))
					end
				end)
			else
				callback2(err.new(result))
			end
		end)
	end

	return fetch
end

return buildFetch
