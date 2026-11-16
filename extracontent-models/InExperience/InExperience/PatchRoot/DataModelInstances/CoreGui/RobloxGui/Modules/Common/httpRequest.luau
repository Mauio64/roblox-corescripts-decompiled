local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local Promise = require(CorePackages.Packages.Promise)

local Extreme = Enum.ThrottlingPriority.Extreme
local ApplicationJson = Enum.HttpContentType.ApplicationJson

return function(object)
	local function doHttpPost(value, state)
		local v = nil
		assert(state.postBody, "Expected a postBody to be specified with this request")

		if type(state.postBody) == "table" then
			v = HttpService:JSONEncode(state.postBody)
		elseif type(state.postBody) == "string" then
			v = state.postBody
		else
			error("Expected postBody to be a string or table")
		end

		if not state.contentType then
			state.contentType = ApplicationJson
		end

		if not state.throttlingPriority then
			state.throttlingPriority = Extreme
		end

		return function()
			return object:PostAsyncFullUrl(value, v, state.throttlingPriority, state.contentType)
		end
	end

	local function doHttpGet(value) -- 1 equivalent call inferred from this helper
		return function()
			return object:GetAsyncFullUrl(value, Extreme)
		end
	end

	return function(value, value2, p)
		assert(type(value) == "string", "Expected url to be a string")
		assert(type(value2) == "string", "Expected requestMethod to be a string")
		assert(not p or type(p) == "table", "Expected options to be a table")
		local v = string.upper(value2)

		local v2 = nil

		if v == "POST" then
			v2 = doHttpPost(value, p)
		elseif v == "GET" then
			v2 = doHttpGet(value) -- inferred equivalent call
		else
			error(string.format("Unsupported requestMethod : %s", v or "nil"))
		end

		return Promise.new(function(callback, callback2)
			if v2 then
				spawn(function()
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
				end)
			else
				callback2()
			end
		end)
	end
end
