local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 4
	-- upvalues: Url (copy)
	return p1(string.format("%sdeveloper-products/v1/universes/%s/store?page=1&pageSize=100&storePageEnabled=true", Url.APIS_URL, p2), "GET")
end
