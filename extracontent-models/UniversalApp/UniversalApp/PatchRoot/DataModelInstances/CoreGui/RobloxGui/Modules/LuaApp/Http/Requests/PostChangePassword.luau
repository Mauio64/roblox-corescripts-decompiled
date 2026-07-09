local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2, p3) -- line: 11
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid current password")
	assert(type(p3) == "string", "invalid new password")

	return p1(string.format("%sv2/user/passwords/change", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			currentPassword = p2,
			newPassword = p3
		})
	})
end
