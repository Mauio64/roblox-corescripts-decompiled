local HttpService = game:GetService("HttpService")

local parseApiError = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/parseApiError")
local parseLegacyError = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/parseLegacyError")
require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local isSuccess = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/httpStatus").isSuccess

local function bodyToString(buf)
	if buf == nil then
		return nil
	end

	if typeof(buf) == "buffer" then
		return buffer.tostring(buf)
	end

	return buf
end

local function tryJsonDecode(buf)
	if buf == nil then
		buf = nil
	elseif typeof(buf) == "buffer" then
		buf = buffer.tostring(buf)
	end

	if buf == nil or buf == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, buf)

	if success then
		return result
	end

	return nil
end

return {
	decodeJson = function(callback)
		return function(p2)
			local responseBody = p2.responseBody

			if responseBody == nil then
				responseBody = nil
			elseif typeof(responseBody) == "buffer" then
				responseBody = buffer.tostring(responseBody)
			end

			local result

			if not (responseBody == nil or responseBody == "") then
				local success
				success, result = pcall(HttpService.JSONDecode, HttpService, responseBody)

				if not success then
					result = nil
				end
			end

			local v5 = parseApiError(result)

			if v5 then
				return nil, `api error {v5.code}: {v5.message}`, v5.code
			end

			if isSuccess(p2.statusCode) then
				return callback(result), nil, nil
			end

			local statusCode = p2.statusCode
			local responseBody2 = p2.responseBody

			if responseBody2 == nil then
				responseBody2 = nil
			elseif typeof(responseBody2) == "buffer" then
				responseBody2 = buffer.tostring(responseBody2)
			end

			return nil, `http {statusCode}: {responseBody2 or ""}`, p2.statusCode
		end
	end,
	decodeLegacyJson = function(callback)
		return function(p2)
			local responseBody = p2.responseBody

			if responseBody == nil then
				responseBody = nil
			elseif typeof(responseBody) == "buffer" then
				responseBody = buffer.tostring(responseBody)
			end

			local result

			if not (responseBody == nil or responseBody == "") then
				local success
				success, result = pcall(HttpService.JSONDecode, HttpService, responseBody)

				if not success then
					result = nil
				end
			end

			local v5 = parseLegacyError(result)

			if v5 then
				local err = v5.errors[1]
				return nil, `api error {err.code}: {err.message}`, err.code
			end

			if isSuccess(p2.statusCode) then
				return callback(result), nil, nil
			end

			local statusCode = p2.statusCode
			local responseBody2 = p2.responseBody

			if responseBody2 == nil then
				responseBody2 = nil
			elseif typeof(responseBody2) == "buffer" then
				responseBody2 = buffer.tostring(responseBody2)
			end

			return nil, `http {statusCode}: {responseBody2 or ""}`, p2.statusCode
		end
	end
}
