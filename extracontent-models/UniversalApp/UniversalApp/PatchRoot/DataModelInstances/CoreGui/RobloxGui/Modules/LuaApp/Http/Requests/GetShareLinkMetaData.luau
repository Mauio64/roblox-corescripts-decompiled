local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

return function(p1, p2, p3) -- line: 5
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v7 = UrlBuilder.fromString("apis:sharelinks/v1/get-metadata")
	local json = HttpService:JSONEncode({
		linkId = p2,
		linkType = p3
	})

	return p1(v7(), "POST", {
		postBody = json
	})
end
