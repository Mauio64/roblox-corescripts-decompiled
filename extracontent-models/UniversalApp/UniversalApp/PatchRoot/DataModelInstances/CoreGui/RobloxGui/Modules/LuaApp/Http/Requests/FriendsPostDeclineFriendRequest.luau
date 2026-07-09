local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 13
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%s/users/%s/decline-friend-request", Url.FRIEND_URL, p2), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
