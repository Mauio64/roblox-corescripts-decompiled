local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 17
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/account/pin", Url.AUTH_URL), "GET")
end
