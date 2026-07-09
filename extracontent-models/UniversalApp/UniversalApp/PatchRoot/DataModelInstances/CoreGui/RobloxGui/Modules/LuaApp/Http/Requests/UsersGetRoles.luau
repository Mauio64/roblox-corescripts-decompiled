local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

return function(p1) -- line: 6
	-- upvalues: UrlBuilder (copy), Url (copy)
	return p1(UrlBuilder.new({
		path = "users/authenticated/roles",
		base = Url.USERS_URL
	})(), "GET")
end
