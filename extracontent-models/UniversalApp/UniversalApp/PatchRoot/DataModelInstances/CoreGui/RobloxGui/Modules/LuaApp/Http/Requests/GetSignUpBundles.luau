local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local v3 = require(Modules.LuaApp.Http.UrlBuilder).new({
	path = "v3/signup/bundles",
	base = Url.AUTH_URL
})

return function(p1) -- line: 15
	-- upvalues: v3 (copy)
	return p1(v3(), "GET")
end
