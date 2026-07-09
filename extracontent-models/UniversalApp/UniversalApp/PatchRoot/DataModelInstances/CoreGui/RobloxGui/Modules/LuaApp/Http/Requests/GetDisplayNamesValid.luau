local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local v3 = require(Modules.LuaApp.Http.UrlBuilder).new({
	path = "display-names/validate",
	query = "displayname={displayname}&birthdate={birthday}",
	base = Url.USERS_URL
})

return function(p1, p2, p3) -- line: 16
	-- upvalues: v3 (copy)
	return p1(v3({
		displayname = p2,
		birthday = p3
	}), "GET", {
		maxRetryCount = 0
	})
end
