local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local decodeFundingError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeFundingError")

local function getFundingError(p2)
	if p2.status ~= "failed" or p2.response == nil then
		return nil, nil
	end

	local responseBody = p2.response.responseBody

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
