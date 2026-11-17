local parent = script.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error

local Promise = require(parent.Promise)

local Response = require(script.Parent.Response)
local response = Response.Response

local Request = require(script.Parent.Request)
local request = Request.Request

local function parseResponse(data) -- 1 equivalent call inferred from this helper
	local body = data.Body

	return response.new(body, {
		status = data.StatusCode,
		statusText = data.StatusMessage,
		headers = data.Headers
	})
end

local function buildFetch(object)
	local function fetch(p, p2)
		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return request.new(p, p2)
			end)

			if success then
				object:RequestInternal({
					Url = result.url,
					Method = result.method,
					Body = result.body,
					Headers = result.headers.headerList,
					CachePolicy = result.cache
				}):Start(function(p3, data)
					if p3 then
						local response2 = parseResponse(data) -- inferred equivalent call
						callback(response2)
					else
						result.signal:fire()
						callback2(Error.new(data.ErrorMessage))
					end
				end)
			else
				callback2(Error.new(result))
			end
		end)
	end

	return fetch
end

return buildFetch
