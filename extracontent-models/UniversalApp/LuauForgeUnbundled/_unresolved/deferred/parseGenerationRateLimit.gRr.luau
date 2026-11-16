local HttpService = game:GetService("HttpService")

local v5 = { minute = true, hour = true, day = true }

local function parseGenerationRateLimit(p2)
	if typeof(p2) ~= "table" or p2.StatusCode ~= 429 or typeof(p2.Body) ~= "string" then
		return false, nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(p2.Body)
	end)

	if not success or typeof(result) ~= "table" or result.error ~= "generation_rate_limited" then
		return false, nil
	end

	local limitWindow = result.limitWindow

	if typeof(limitWindow) == "string" and v5[limitWindow] then
		return true, limitWindow
	end

	return true, nil
end

return parseGenerationRateLimit
