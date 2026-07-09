local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 5
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid delivery target")

	return p1(string.format("%sv1/verified-signup/challenge", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			deliveryMethod = 0,
			deliveryTarget = p2
		})
	})
end
