local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 11
	-- upvalues: Url (copy)
	return p1(string.format("%s/users/authenticated", Url.USERS_URL), "GET", {
		maxRetryCount = 0
	})
end
