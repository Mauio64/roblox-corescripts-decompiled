local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local v3 = require(Modules.LuaApp.Http.UrlBuilder).new({
	path = "/v2/passwords/validate",
	query = "request.username={username}&request.password={password}",
	base = Url.AUTH_URL
})

return function(p1, p2, p3) -- line: 15
	-- upvalues: v3 (copy)
	return p1(v3({
		username = p2,
		password = p3
	}), "GET", {
		maxRetryCount = 0
	})
end
