local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation()
	local baseUrl = ContentProvider.BaseUrl

	if baseUrl:sub(#baseUrl) == "/" then
		baseUrl = baseUrl:sub(1, #baseUrl - 1)
	end

	local _, v = baseUrl:find("://")

	assert(type(v) == "number", "Expected schemeEnd to be a number")

	local v2, v3 = baseUrl:find("%.", v + 1)
	assert(type(v2) == "number", "Expected prefixIndex to be a number")
	assert(type(v3) == "number", "Expected prefixEnd to be a number")

	return baseUrl, baseUrl:sub(v + 1, v2 - 1), (baseUrl:sub(v3 + 1))
end

local _, _, v = parseBaseUrlInformation()

return function(value: string)
	assert(type(value) == "string", "siteName must be a string")
	return string.format("https://%s.%s", value, v)
end
