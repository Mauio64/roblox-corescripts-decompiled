local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local HttpService = game:GetService("HttpService")

return function(p1, p2, p3) -- line: 14
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "string", "FollowingsPostFollow request expects userId to be a string")
	assert(type(p3) == "string", "FollowingsPostFollow request expects universeId to be a string")

	return p1(string.format("%s/v1/users/%s/universes/%s", Url.FOLLOWINGS_URL, p2, p3), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
