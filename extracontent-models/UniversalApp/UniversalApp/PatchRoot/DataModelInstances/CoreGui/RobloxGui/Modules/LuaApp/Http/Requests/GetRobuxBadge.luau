local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 16
	-- upvalues: Url (copy)
	return p1(string.format("%s/robuxbadge/v1/robuxbadge", Url.APIS_URL), "GET")
end
