local HttpService = game:GetService("HttpService")

local Promise = require(script.Parent.Parent.Utility.Promise)

local Extreme = Enum.ThrottlingPriority.Extreme
local ApplicationJson = Enum.HttpContentType.ApplicationJson

return function(object)
	local function doHttpPost(value, state) -- 1 equivalent call inferred from this helper
		assert(state.postBody, "Expected a postBody to be specified with this request")
		assert(type(state.postBody) == "string", "Expected postBody to be a string")

		if not state.contentType then
			state.contentType = ApplicationJson
		end

		if not state.throttlingPriority then
			state.throttlingPriority = Extreme
		end

		return function()
			return object:PostAsyncFullUrl(value, state.postBody, state.throttlingPriority, state.contentType)
		end
	end

	local function doHttpGet(value) -- 1 equivalent call inferred from this helper
		return function()
			return object:GetAsyncFullUrl(value, Extreme)
		end
	end

	return function(value, value2, state)
		assert(type(value) == "string", "Expected url to be a string")
		assert(type(value2) == "string", "Expected requestMethod to be a string")
		assert(not state or type(state) == "table", "Expected options to be a table")
		local v = string.upper(value2)

		local v2 = nil

		if v == "POST" then
			v2 = doHttpPost(value, state) -- inferred equivalent call
		elseif v == "GET" then
			v2 = doHttpGet(value) -- inferred equivalent call
		else
			error(string.format("Unsupported requestMethod : %s", v or "nil"))
		end

		return Promise.new(function(callback, callback2)
			if v2 then
				coroutine.wrap(function()
					local success, result = pcall(v2)

					if not success then
						callback2(result)

						return
					end

					local success2, result2 = pcall(function()
						return HttpService:JSONDecode(result)
					end)

					if success2 then
						callback({ responseBody = result2 })
					else
						callback2(result2)
					end
				end)()
			else
				callback2()
			end
		end)
	end
end
