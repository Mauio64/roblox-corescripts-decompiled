local HttpService = game:GetService("HttpService")

local parseApiError = require(script.Parent.parseApiError)
local parseLegacyError = require(script.Parent.parseLegacyError)
require(script.Parent.types)
local httpStatus = require(script.Parent.httpStatus)
local isSuccess = httpStatus.isSuccess

local function bodyToString(buf) -- 5 equivalent calls inferred from this helper
	if buf == nil then
		return nil
	end

	if typeof(buf) == "buffer" then
		return buffer.tostring(buf)
	end

	return buf
end

local function tryJsonDecode(p)
	p = bodyToString(p) -- inferred equivalent call

	if p == nil or p == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p)
	return if success then result else nil
end

local Decoders = {}

function Decoders.decodeJson(callback)
	return function(p)
		local v = bodyToString(p.responseBody) -- inferred equivalent call
		local result

		if not (v == nil or v == "") then
			local success
			success, result = pcall(HttpService.JSONDecode, HttpService, v)

			if not success then
				result = nil
			end
		end

		local v2 = parseApiError(result)

		if v2 then
			return nil, `api error {v2.code}: {v2.message}`, v2.code
		end

		if isSuccess(p.statusCode) then
			return callback(result), nil, nil
		end

		return nil, `http {p.statusCode}: {bodyToString(p.responseBody) or ""}`, p.statusCode -- inferred equivalent call
	end
end

function Decoders.decodeLegacyJson(callback)
	return function(p)
		local v = bodyToString(p.responseBody) -- inferred equivalent call
		local result

		if not (v == nil or v == "") then
			local success
			success, result = pcall(HttpService.JSONDecode, HttpService, v)

			if not success then
				result = nil
			end
		end

		local v2 = parseLegacyError(result)

		if v2 then
			local err = v2.errors[1]
			return nil, `api error {err.code}: {err.message}`, err.code
		end

		if isSuccess(p.statusCode) then
			return callback(result), nil, nil
		end

		return nil, `http {p.statusCode}: {bodyToString(p.responseBody) or ""}`, p.statusCode -- inferred equivalent call
	end
end

return Decoders
