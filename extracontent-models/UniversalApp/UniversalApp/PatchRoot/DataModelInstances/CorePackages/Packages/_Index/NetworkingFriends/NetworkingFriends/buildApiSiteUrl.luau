local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation() -- line: 7
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if BaseUrl:sub(#BaseUrl) ~= "/" then
		BaseUrl ..= "/"
	end

	local _, stop = BaseUrl:find("://")

	assert(type(stop) == "number", "Expected schemeEnd to be a number")

	local start, stop2 = BaseUrl:find("%.", stop + 1)

	assert(type(start) == "number", "Expected prefixIndex to be a number")
	assert(type(stop2) == "number", "Expected prefixEnd to be a number")

	return BaseUrl, BaseUrl:sub(stop + 1, start - 1), (BaseUrl:sub(stop2 + 1))
end

local _, _, v5 = parseBaseUrlInformation()

return function(s1: string) -- line: 37
	-- upvalues: v5 (copy)
	return string.format("https://%s.%s", s1, v5)
end
