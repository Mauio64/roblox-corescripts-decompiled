local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation()
	local selected = ContentProvider.BaseUrl

	if selected:sub(#selected) ~= "/" then
		selected ..= "/"
	end

	local _, v = selected:find("://")

	local v2, v3 = selected:find("%.", v + 1)
	return selected, selected:sub(v + 1, v2 - 1), (selected:sub(v3 + 1))
end

local _, _, v = parseBaseUrlInformation()

return function(p)
	return string.format("https://%s.%s", p, v)
end
