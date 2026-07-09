local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 12
	-- upvalues: Url (copy)
	assert(type(p2) == "string", "EconomyGetCurrency request expects userId to be a string")

	return p1(string.format("%s/v1/users/%s/currency", Url.ECONOMY_URL, p2), "GET")
end
