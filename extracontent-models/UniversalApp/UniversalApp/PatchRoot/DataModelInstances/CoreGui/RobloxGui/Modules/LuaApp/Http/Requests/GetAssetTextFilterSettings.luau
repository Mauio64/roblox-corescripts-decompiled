local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local v3 = require(Modules.LuaApp.Http.UrlBuilder).new({
	path = "asset-text-filter-settings/public/universe/{universeId}",
	base = Url.APIS_URL
})

return function(p1, p2) -- line: 22
	-- upvalues: v3 (copy)
	assert(type(p2) == "string", "GetAssetTextFilterSettings request expects universeId to be a string")

	return p1(v3({
		universeId = p2
	}), "GET")
end
