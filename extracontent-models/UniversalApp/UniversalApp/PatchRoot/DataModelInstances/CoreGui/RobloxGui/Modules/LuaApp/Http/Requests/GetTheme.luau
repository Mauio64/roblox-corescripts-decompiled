local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 7
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/themes/User/%d", Url.ACCOUNT_SETTINGS, p2), "GET")
end
