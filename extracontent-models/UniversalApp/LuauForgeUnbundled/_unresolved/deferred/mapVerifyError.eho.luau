local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/egW")
require("@luauforge/deferred/egX")

local verifyErrorKind = module.VerifyErrorKind

local function extractBody(value)
	if value == nil then
		return nil
	end

	local v5 = string.match(value, "^http %d+: (.+)$")

	if v5 ~= nil and v5 ~= "" then
		return v5
	end

	if string.sub(value, 1, 1) == "{" then
		return value
	end

	return nil
end

local function extractErrorCodes(errorMessage)
	if errorMessage == nil then
		errorMessage = nil
	else
		local v5 = string.match(errorMessage, "^http %d+: (.+)$")

		if v5 == nil or v5 == "" then
			if string.sub(errorMessage, 1, 1) ~= "{" then
				errorMessage = nil
			end
		else
			errorMessage = v5
		end
	end

	if errorMessage == nil then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, errorMessage)

	if not success or typeof(result) ~= "table" then
		return nil
	end

	local errors = result.errors

	if typeof(errors) ~= "table" then
		return nil
	end

	local codes = {}

	for k, err in errors do
		if not (typeof(err) == "table" and typeof(err.code) == "string") then
			continue
		end

		table.insert(codes, err.code)
	end

	if #codes > 0 then
		return codes
	end

	return nil
end

local function mapVerifyError(p2, p3, p4)
	local responseCode = if typeof(p2) == "table" then p2.responseCode else nil
	local errorMessage = if typeof(p2) == "table" then p2.errorMessage else nil

	if responseCode == nil then
		return { kind = verifyErrorKind.Network, message = errorMessage }
	end

	if p3 ~= nil then
		local v5 = extractErrorCodes(errorMessage)

		if v5 ~= nil then
			for k, v6 in v5 do
				if p3[v6] ~= nil then
					return { kind = p3[v6], message = errorMessage }
				end
			end
		end
	end

	if p4 == nil or p4[responseCode] == nil then
		return { kind = verifyErrorKind.Unknown, message = errorMessage }
	end

	return { kind = p4[responseCode], message = errorMessage }
end

return mapVerifyError
