local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 11
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "string", "PostRegisterAppPresence request expects locationId to be a string")

	return p1(string.format("%s/presence/register-app-presence", Url.PRESENCE_URL), "POST", {
		postBody = HttpService:JSONEncode({
			location = p2
		})
	})
end
