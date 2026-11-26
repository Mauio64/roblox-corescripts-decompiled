local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local function parseMomentsLimitError(p2)
	local errorMessage = if type(p2) == "table" then p2.errorMessage else nil

	if type(errorMessage) ~= "string" then
		return nil
	end

	local v5 = string.find(errorMessage, "{", 1, true)

	if v5 == nil then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, (string.sub(errorMessage, v5)))

	if not success or type(result) ~= "table" then
		return nil
	end

	local limitSeconds = result.limitSeconds

	if result.errorCode ~= "MomentsDailyLimitReached" or type(limitSeconds) ~= "number" then
		return nil
	end

	local v7 = if type(result.resetsAt) == "string" then result.resetsAt else nil
	return { limitSeconds = limitSeconds, resetsAt = v7 }
end

return parseMomentsLimitError
