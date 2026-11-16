local HttpService = game:GetService("HttpService")

local v5 = { Hourly = true, Daily = true, Monthly = true, AllTime = true }

local function parseUploadQuotaError(p2)
	if typeof(p2) ~= "table" or p2.StatusCode ~= 429 or typeof(p2.Body) ~= "string" then
		return false, nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(p2.Body)
	end)

	if not success or typeof(result) ~= "table" or result.error ~= "upload_quota_reached" then
		return false, nil
	end

	local quotaPeriod = result.quotaPeriod

	if typeof(quotaPeriod) == "string" and v5[quotaPeriod] then
		return true, quotaPeriod
	end

	return true, nil
end

return parseUploadQuotaError
