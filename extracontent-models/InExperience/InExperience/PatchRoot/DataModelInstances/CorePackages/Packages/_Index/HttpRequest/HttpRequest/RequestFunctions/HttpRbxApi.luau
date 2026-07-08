local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local StatusCode = require(script.Parent.Parent.StatusCode)
local Extreme = Enum.ThrottlingPriority.Extreme
local ApplicationJson = Enum.HttpContentType.ApplicationJson

local function doHttpGet(p1, p2) -- line: 9
	-- upvalues: HttpRbxApiService (copy), Extreme (copy)
	return pcall(function() -- line: 10
		-- upvalues: HttpRbxApiService (copy), p1 (copy), p2 (copy), Extreme (copy)
		return HttpRbxApiService:GetAsyncFullUrl(p1, p2.throttlingPriority or Extreme, p2.httpRequestType or nil)
	end)
end
local function doHttpPost(p3, p4) -- line: 19
	-- upvalues: HttpService (copy), HttpRbxApiService (copy), Extreme (copy), ApplicationJson (copy)
	local json = nil

	assert(p4.postBody, "Expected a postBody to be specified with this request")

	if type(p4.postBody) == "table" then
		json = HttpService:JSONEncode(p4.postBody)
	elseif type(p4.postBody) == "string" then
		json = p4.postBody
	else
		error("Expected postBody to be a string or table")
	end

	return pcall(function() -- line: 30
		-- upvalues: HttpRbxApiService (copy), p3 (copy), json (ref), p4 (copy), Extreme (copy), ApplicationJson (copy)
		return HttpRbxApiService:PostAsyncFullUrl(p3, json, p4.throttlingPriority or Extreme, p4.contentType or ApplicationJson, p4.httpRequestType or nil)
	end)
end
local function createResponse(p5) -- line: 41
	-- upvalues: StatusCode (copy), HttpService (copy)
	local OK = StatusCode.OK
	local ok, _ = pcall(function() -- line: 44
		-- upvalues: HttpService (copy), p5 (copy)
		return HttpService:JSONDecode(p5)
	end)

	if not ok then
		OK = tonumber(p5:sub(6, 8))
	end

	return {
		Body = p5,
		StatusCode = OK,
		Headers = {}
	}
end

return function(p6, p7, p8) -- line: 61
	-- upvalues: HttpRbxApiService (copy), Extreme (copy), doHttpPost (copy), createResponse (copy)
	return {
		Start = function(_, p10) -- line: 63
			-- upvalues: p7 (copy), p6 (copy), p8 (copy), HttpRbxApiService (copy), Extreme (copy), doHttpPost (copy), createResponse (copy)
			local ok = nil
			local result = nil

			if p7 == "GET" then
				local v25 = p6
				local v26 = p8

				ok, result = pcall(function() -- line: 10
					-- upvalues: HttpRbxApiService (copy), v25 (copy), v26 (copy), Extreme (copy)
					return HttpRbxApiService:GetAsyncFullUrl(v25, v26.throttlingPriority or Extreme, v26.httpRequestType or nil)
				end)
			elseif p7 == "POST" then
				ok, result = doHttpPost(p6, p8)
			else
				error("Unsupported method: " .. p7)
			end

			p10(ok, (createResponse(result)))
		end,
		Cancel = function() -- line: 77
		end
	}
end
