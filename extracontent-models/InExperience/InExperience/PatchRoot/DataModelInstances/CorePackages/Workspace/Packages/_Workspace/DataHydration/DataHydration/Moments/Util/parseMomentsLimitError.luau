local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.Moments.MomentsStoreTypes)

local function parseMomentsLimitError(p)
	local errorMessage

	if type(p) == "table" then
		errorMessage = p.errorMessage
	end

	if type(errorMessage) ~= "string" then
		return nil
	end

	local v = string.find(errorMessage, "{", 1, true)

	if v == nil then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, (string.sub(errorMessage, v)))

	if not success or type(result) ~= "table" then
		return nil
	end

	local limitSeconds = result.limitSeconds

	if result.errorCode ~= "MomentsDailyLimitReached" or type(limitSeconds) ~= "number" then
		return nil
	end

	local resetsAt

	if type(result.resetsAt) == "string" then
		resetsAt = result.resetsAt
	end

	return { limitSeconds = limitSeconds, resetsAt = resetsAt }
end

return parseMomentsLimitError
