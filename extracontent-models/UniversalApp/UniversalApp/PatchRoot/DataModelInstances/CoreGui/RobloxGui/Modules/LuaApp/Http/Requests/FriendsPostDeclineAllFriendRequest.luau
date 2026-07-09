local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 12
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%s/user/friend-requests/decline-all", Url.FRIEND_URL), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
