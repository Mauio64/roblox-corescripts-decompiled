local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 11
	-- upvalues: Url (copy)
	return p1(("%s/v1/user/currency"):format(Url.ECONOMY_URL), "GET")
end
