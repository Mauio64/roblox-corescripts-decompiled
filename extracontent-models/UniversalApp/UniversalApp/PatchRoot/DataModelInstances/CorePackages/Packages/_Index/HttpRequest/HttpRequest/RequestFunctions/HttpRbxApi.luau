local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local StatusCode = require(script.Parent.Parent.StatusCode)

local Extreme = Enum.ThrottlingPriority.Extreme
local ApplicationJson = Enum.HttpContentType.ApplicationJson

local function doHttpGet(p, p2) -- 1 equivalent call inferred from this helper
	return pcall(function()
		return HttpRbxApiService:GetAsyncFullUrl(p, p2.throttlingPriority or Extreme, p2.httpRequestType or nil)
	end)
end

local function doHttpPost(p, data)
	local v = nil
	assert(data.postBody, "Expected a postBody to be specified with this request")

	if type(data.postBody) == "table" then
		v = HttpService:JSONEncode(data.postBody)
	elseif type(data.postBody) == "string" then
		v = data.postBody
	else
		error("Expected postBody to be a string or table")
	end

	return pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(
			p,
			v,
			data.throttlingPriority or Extreme,
			data.contentType or ApplicationJson,
			data.httpRequestType or nil
		)
	end)
end

local function createResponse(json)
	local statusCode = StatusCode.OK

	local success, _ = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if not success then
		statusCode = tonumber(json:sub(6, 8))
	end

	return { Body = json, StatusCode = statusCode, Headers = {} }
end

return function(p, p2, p3)
	return {
		Start = function(_, callback)
			local v = nil
			local v2 = nil

			if p2 == "GET" then
				v, v2 = doHttpGet(p, p3) -- inferred equivalent call
			elseif p2 == "POST" then
				v, v2 = doHttpPost(p, p3)
			else
				error("Unsupported method: " .. p2)
			end

			callback(v, createResponse(v2))
		end,
		Cancel = function() end
	}
end
