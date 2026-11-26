local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")

local function parseCommentsError(value)
	if type(value) ~= "string" or value == "" then
		return nil
	end

	local v5 = string.find(value, "{", 1, true)

	if v5 ~= nil then
		value = string.sub(value, v5)
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, value)

	if not success or type(result) ~= "table" then
		return nil
	end

	if type(result.errorCode) == "string" and type(result.message) == "string" then
		return { errorCode = result.errorCode, message = result.message }
	end

	return nil
end

return parseCommentsError
