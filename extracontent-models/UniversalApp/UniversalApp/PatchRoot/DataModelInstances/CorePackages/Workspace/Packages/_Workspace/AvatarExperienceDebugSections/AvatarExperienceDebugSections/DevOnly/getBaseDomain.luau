local ContentProvider = game:GetService("ContentProvider")

local function getBaseDomain() -- line: 3
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if BaseUrl:sub(#BaseUrl) == "/" then
		BaseUrl = BaseUrl:sub(1, #BaseUrl - 1)
	end

	local _, stop = BaseUrl:find("://")
	local _, stop2 = BaseUrl:find("%.", stop + 1)

	return BaseUrl:sub(stop2 + 1)
end

return getBaseDomain
