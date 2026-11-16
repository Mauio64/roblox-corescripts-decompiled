local HttpService = game:GetService("HttpService")

local function buildQueryString(items)
	local v = {}

	for k, item in pairs(items) do
		table.insert(
			v,
			string.format("%s=%s", HttpService:UrlEncode((tostring(k))), HttpService:UrlEncode((tostring(item))))
		)
	end

	if #v == 0 then
		return ""
	end

	return "?" .. table.concat(v, "&")
end

return buildQueryString
