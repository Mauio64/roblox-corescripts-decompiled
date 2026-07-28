local HttpService = game:GetService("HttpService")

local function buildQueryString(t1: {[any]: any}) -- line: 10
	-- upvalues: HttpService (copy)
	local t2 = {}

	for k, v in pairs(t1) do
		table.insert(t2, string.format("%s=%s", HttpService:UrlEncode((tostring(k))), HttpService:UrlEncode((tostring(v)))))
	end

	if #t2 == 0 then
		return ""
	end

	return "?" .. table.concat(t2, "&")
end

return buildQueryString
