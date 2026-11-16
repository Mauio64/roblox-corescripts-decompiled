local HttpService = game:GetService("HttpService")

local function parseGamePassTrialRedeemErrorCode(p)
	if typeof(p) ~= "table" then
		return nil
	end

	local errorMessage = p.errorMessage

	if type(errorMessage) ~= "string" then
		return nil
	end

	local v = string.find(errorMessage, "{", 1, true)

	if v == nil then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, (string.sub(errorMessage, v)))

	if success and type(result) == "table" and type(result.errorCode) == "string" then
		return result.errorCode
	end

	return nil
end

return parseGamePassTrialRedeemErrorCode
