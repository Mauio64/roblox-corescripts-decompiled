local HttpService = game:GetService("HttpService")

require(script.Parent.types)
local decodeFundingError = require(script.Parent.decodeFundingError)

local function getFundingError(p)
	if p.status ~= "failed" or p.response == nil then
		return nil, nil
	end

	local responseBody = p.response.responseBody

	if responseBody == nil or responseBody == "" then
		return nil, nil
	end

	if typeof(responseBody) == "buffer" then
		responseBody = buffer.tostring(responseBody)
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, responseBody)

	if success and typeof(result) == "table" then
		return decodeFundingError(result.error)
	end

	return nil, nil
end

return getFundingError
