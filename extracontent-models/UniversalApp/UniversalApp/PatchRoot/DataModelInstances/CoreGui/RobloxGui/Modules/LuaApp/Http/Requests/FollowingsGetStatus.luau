local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2, p3) -- line: 22
	-- upvalues: Url (copy)
	assert(type(p2) == "string", "FollowingsGetStatus request expects userId to be a string")
	assert(type(p3) == "string", "FollowingsGetStatus request expects universeId to be a string")

	return p1(string.format("%s/v1/users/%s/universes/%s/status", Url.FOLLOWINGS_URL, p2, p3), "GET")
end
