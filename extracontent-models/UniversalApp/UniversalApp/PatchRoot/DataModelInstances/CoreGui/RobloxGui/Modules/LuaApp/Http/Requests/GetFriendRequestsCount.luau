local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 15
	-- upvalues: Url (copy)
	return p1(string.format("%s/user/friend-requests/count", Url.FRIEND_URL), "GET")
end
