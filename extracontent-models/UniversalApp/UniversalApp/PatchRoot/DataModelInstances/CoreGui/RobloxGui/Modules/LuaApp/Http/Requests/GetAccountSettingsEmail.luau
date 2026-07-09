local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 16
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/email", Url.ACCOUNT_SETTINGS_URL), "GET")
end
