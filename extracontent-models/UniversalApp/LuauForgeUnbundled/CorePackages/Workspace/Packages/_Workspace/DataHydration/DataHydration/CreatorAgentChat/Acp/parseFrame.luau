local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local function trim(value)
	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function stripFrame(value)
	local v5 = value:gsub("^%s+", ""):gsub("%s+$", "")

	if not (v5 ~= "" and v5:sub(1, 1) ~= ":") then
		return nil
	end

	if v5:sub(1, 5) == "data:" then
		v5 = v5:sub(6):gsub("^%s+", ""):gsub("%s+$", "")

		if v5 == "" or v5 == "[DONE]" then
			return nil
		end
	end

	return v5
end

local function parseFrame(p2)
	local v5 = stripFrame(p2)

	if v5 == nil then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, v5)

	if not success or typeof(result) ~= "table" or result.jsonrpc == nil then
		return nil
	end

	local v6 = typeof(result.method) == "string" and result.method ~= ""
	local v7 = result.id ~= nil
	local v8 = typeof(result.error) == "table"

	if v6 and not v7 then
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
	elseif v7 and v8 and not v6 then
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
