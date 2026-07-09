local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 13
	-- upvalues: Url (copy)
	return p1(string.format("%smaintenance-status/v1/alerts/alert-info", Url.APIS_URL), "GET")
end
