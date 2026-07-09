local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 49
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/products", Url.PREMIUM_FEATURES), "GET")
end
