local HttpService = game:GetService("HttpService")

local function withAnalyticsSessionId(value: string, p: string?)
	if p == nil or p == "" then
		return value
	end

	local v = string.find(value, "#", 1, true)
	local v2

	if v == nil then
		v2 = value
	else
		v2 = string.sub(value, 1, v - 1)
	end

	local v3 = v == nil and "" or string.sub(value, v)

	if string.match(v2, "[?&]analyticsSessionId=") == nil then
		return `{v2}{string.find(v2, "?", 1, true) == nil and "?" or "&"}analyticsSessionId={HttpService:UrlEncode(p)}{v3}`
	end

	return value
end

return withAnalyticsSessionId
