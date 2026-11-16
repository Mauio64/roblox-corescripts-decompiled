local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation()
	local v = ContentProvider.BaseUrl

	if v:sub(#v) ~= "/" then
		v ..= "/"
	end

	local _, v2 = v:find("://")
	assert(type(v2) == "number", "Expected schemeEnd to be a number")

	local v3, v4 = v:find("%.", v2 + 1)
	assert(type(v3) == "number", "Expected prefixIndex to be a number")
	assert(type(v4) == "number", "Expected prefixEnd to be a number")

	return v, v:sub(v2 + 1, v3 - 1), (v:sub(v4 + 1))
end

local _, _, v = parseBaseUrlInformation()

return function(p: string)
	return string.format("https://%s.%s", p, v)
end
