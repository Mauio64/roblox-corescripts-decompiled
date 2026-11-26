local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation()
	local baseUrl = ContentProvider.BaseUrl

	if baseUrl:sub(#baseUrl) == "/" then
		baseUrl = baseUrl:sub(1, #baseUrl - 1)
	end

	local v5, v6 = baseUrl:find("://")

	assert(type(v6) == "number", "Expected schemeEnd to be a number")

	local v7, v8 = baseUrl:find("%.", v6 + 1)
	assert(type(v7) == "number", "Expected prefixIndex to be a number")
	assert(type(v8) == "number", "Expected prefixEnd to be a number")

	return baseUrl, baseUrl:sub(v6 + 1, v7 - 1), (baseUrl:sub(v8 + 1))
end

local v5, v6, v7 = parseBaseUrlInformation()

return function(value)
	assert(type(value) == "string", "siteName must be a string")
	return string.format("https://%s.%s", value, v7)
end
