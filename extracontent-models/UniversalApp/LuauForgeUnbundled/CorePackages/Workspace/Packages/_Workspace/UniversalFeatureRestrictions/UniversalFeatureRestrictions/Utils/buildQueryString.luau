local HttpService = game:GetService("HttpService")

local function buildQueryString(items)
	local v5 = {}

	for k, item in pairs(items) do
		table.insert(
			v5,
			string.format(
				"%s=%s",
				HttpService:UrlEncode((tostring(k))),
				HttpService:UrlEncode((tostring(item)))
			)
		)
	end

	if #v5 == 0 then
		return ""
	end

	return "?" .. table.concat(v5, "&")
end

return buildQueryString
