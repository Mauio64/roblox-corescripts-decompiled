local HttpService = game:GetService("HttpService")

require(script.Parent.Parent.types)

local function trim(value: string) -- 2 equivalent calls inferred from this helper
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function stripFrame(value: string)
	local v = trim(value) -- inferred equivalent call

	if not (v ~= "" and v:sub(1, 1) ~= ":") then
		return nil
	end

	if v:sub(1, 5) == "data:" then
		v = trim(v:sub(6)) -- inferred equivalent call

		if v == "" or v == "[DONE]" then
			return nil
		end
	end

	return v
end

local function parseFrame(p: string)
	local v = stripFrame(p)

	if v == nil then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, v)

	if not success or typeof(result) ~= "table" or result.jsonrpc == nil then
		return nil
	end

	local v2

	if typeof(result.method) == "string" then
		v2 = result.method ~= ""
	else
		v2 = false
	end

	local v3 = result.id ~= nil
	local v4 = typeof(result.error) == "table"

	if v2 and not v3 then
		local params = result.params

		if params == nil or typeof(params) == "table" then
			return {
				kind = "notification",
				notification = {
					method = result.method,
					params = params or {}
				}
			}
		end

		return nil
	elseif v3 and v4 and not v2 then
		return {
			kind = "response",
			response = {
				jsonrpc = result.jsonrpc,
				id = result.id,
				result = nil,
				error = result.error
			}
		}
	else
		return nil
	end
end

return parseFrame
