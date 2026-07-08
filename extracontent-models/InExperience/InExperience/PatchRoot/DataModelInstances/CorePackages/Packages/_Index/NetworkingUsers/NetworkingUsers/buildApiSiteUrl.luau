local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation() -- line: 6
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if BaseUrl:sub(#BaseUrl) ~= "/" then
		BaseUrl ..= "/"
	end

	local _, stop = BaseUrl:find("://")
	local start, stop2 = BaseUrl:find("%.", stop + 1)

	return BaseUrl, BaseUrl:sub(stop + 1, start - 1), (BaseUrl:sub(stop2 + 1))
end

local _, _, v5 = parseBaseUrlInformation()

return function(p1) -- line: 31
	-- upvalues: v5 (copy)
	return string.format("https://%s.%s", p1, v5)
end
