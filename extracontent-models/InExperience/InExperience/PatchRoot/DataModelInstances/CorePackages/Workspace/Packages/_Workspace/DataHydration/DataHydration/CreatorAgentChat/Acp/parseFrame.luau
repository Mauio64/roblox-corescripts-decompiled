local HttpService = game:GetService("HttpService")

require(script.Parent.Parent.types)

local function trim(s1: string) -- line: 10
	return (s1:gsub("^%s+", ""):gsub("%s+$", ""))
end
local function stripFrame(s2: string) -- line: 14
	local v7 = s2:gsub("^%s+", ""):gsub("%s+$", "")

	if v7 == "" then
		return nil
	end

	if v7:sub(1, 1) == ":" then
		return nil
	end

	if v7:sub(1, 5) == "data:" then
		v7 = v7:sub(6):gsub("^%s+", ""):gsub("%s+$", "")

		if v7 == "" or v7 == "[DONE]" then
			return nil
		end
	end

	return v7
end
local function parseFrame(s3: string) -- line: 31
	-- upvalues: stripFrame (copy), HttpService (copy)
	local v9 = stripFrame(s3)

	if v9 == nil then
		return nil
	end

	local ok, result = pcall(HttpService.JSONDecode, HttpService, v9)

	if not ok or typeof(result) ~= "table" then
		return nil
	end

	if result.jsonrpc == nil then
		return nil
	end

	local v12 = typeof(result.method) == "string" and result.method ~= ""
	local v13 = result.id ~= nil
	local v14 = typeof(result.error) == "table"

	if v12 and not v13 then
		local params = result.params

		if params ~= nil and typeof(params) ~= "table" then
			return nil
		end

		local v16 = params or {}

		return {
			kind = "notification",
			notification = {
				method = result.method,
				params = v16
			}
		}
	end

	if v13 and v14 and not v12 then
		return {
			kind = "response",
			response = {
				result = nil,
				jsonrpc = result.jsonrpc,
				id = result.id,
				error = result.error
			}
		}
	end

	return nil
end

return parseFrame
