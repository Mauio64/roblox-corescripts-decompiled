local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)

local function parseCommentsError(value: string?)
	if type(value) ~= "string" or value == "" then
		return nil
	end

	local v = string.find(value, "{", 1, true)

	if v ~= nil then
		value = string.sub(value, v)
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
