local HttpService = game:GetService("HttpService")

local function withAnalyticsSessionId(value, p2)
	if p2 == nil or p2 == "" then
		return value
	end

	local v5 = string.find(value, "#", 1, true)
	local v6 = if v5 == nil then value else string.sub(value, 1, v5 - 1)
	local v7 = v5 == nil and "" or string.sub(value, v5)

	if string.match(v6, "[?&]analyticsSessionId=") == nil then
		return `{v6}{string.find(v6, "?", 1, true) == nil and "?" or "&"}analyticsSessionId={HttpService:UrlEncode(p2)}{v7}`
	end

	return value
end

return withAnalyticsSessionId
