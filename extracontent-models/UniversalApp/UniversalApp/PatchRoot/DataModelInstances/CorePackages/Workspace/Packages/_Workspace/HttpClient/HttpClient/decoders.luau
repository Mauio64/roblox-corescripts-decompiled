local HttpService = game:GetService("HttpService")
local parseApiError = require(script.Parent.parseApiError)
local parseLegacyError = require(script.Parent.parseLegacyError)

require(script.Parent.types)

local isSuccess = require(script.Parent.httpStatus).isSuccess

local function bodyToString(p1) -- line: 11
	if p1 == nil then
		return nil
	end

	if typeof(p1) == "buffer" then
		return buffer.tostring(p1)
	end

	return p1
end
local function tryJsonDecode(p2) -- line: 21
	-- upvalues: HttpService (copy)
	local v9 = if p2 ~= nil then if typeof(p2) ~= "buffer" then p2 else buffer.tostring(p2) else nil

	if v9 == nil or v9 == "" then
		return nil
	end

	local ok, result = pcall(HttpService.JSONDecode, HttpService, v9)

	if ok then
		return result
	end

	return nil
end

return {
	decodeJson = function(p3: ((...any) -> ...any)) -- line: 30
		-- upvalues: HttpService (copy), parseApiError (copy), isSuccess (copy)
		return function(p4) -- line: 31
			-- upvalues: HttpService (copy), parseApiError (copy), isSuccess (copy), p3 (copy)
			local responseBody = p4.responseBody
			local v16 = if responseBody ~= nil then if typeof(responseBody) ~= "buffer" then responseBody else buffer.tostring(responseBody) else nil
			local v17

			if v16 == nil or v16 == "" then
				v17 = nil
			else
				local ok, result = pcall(HttpService.JSONDecode, HttpService, v16)

				v17 = if not ok then nil else result
			end

			local v20 = parseApiError(v17)

			if v20 then
				return nil, `api error { v20.code }: { v20.message }`, v20.code
			end

			if not isSuccess(p4.statusCode) then
				local statusCode = p4.statusCode
				local responseBody2 = p4.responseBody

				return nil, `http { statusCode }: { ((if responseBody2 ~= nil then (if typeof(responseBody2) ~= "buffer" then responseBody2 else buffer.tostring(responseBody2)) else nil)) or "" }`, p4.statusCode
			end

			return p3(v17), nil, nil
		end
	end,
	decodeLegacyJson = function(p5: ((...any) -> ...any)) -- line: 44
		-- upvalues: HttpService (copy), parseLegacyError (copy), isSuccess (copy)
		return function(p6) -- line: 45
			-- upvalues: HttpService (copy), parseLegacyError (copy), isSuccess (copy), p5 (copy)
			local responseBody = p6.responseBody
			local v25 = if responseBody ~= nil then if typeof(responseBody) ~= "buffer" then responseBody else buffer.tostring(responseBody) else nil
			local v26

			if v25 == nil or v25 == "" then
				v26 = nil
			else
				local ok, result = pcall(HttpService.JSONDecode, HttpService, v25)

				v26 = if not ok then nil else result
			end

			local v29 = parseLegacyError(v26)

			if v29 then
				local v30 = v29.errors[1]

				return nil, `api error { v30.code }: { v30.message }`, v30.code
			end

			if not isSuccess(p6.statusCode) then
				local statusCode = p6.statusCode
				local responseBody3 = p6.responseBody

				return nil, `http { statusCode }: { ((if responseBody3 ~= nil then (if typeof(responseBody3) ~= "buffer" then responseBody3 else buffer.tostring(responseBody3)) else nil)) or "" }`, p6.statusCode
			end

			return p5(v26), nil, nil
		end
	end
}
