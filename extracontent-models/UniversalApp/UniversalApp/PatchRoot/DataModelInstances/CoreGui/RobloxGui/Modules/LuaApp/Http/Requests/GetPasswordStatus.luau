local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 15
	-- upvalues: Url (copy)
	return p1(string.format("%sv2/passwords/current-status", Url.AUTH_URL), "GET")
end
