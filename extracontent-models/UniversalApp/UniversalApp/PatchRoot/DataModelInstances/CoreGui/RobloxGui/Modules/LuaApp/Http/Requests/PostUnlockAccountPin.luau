local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 16
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid account PIN")

	return p1(string.format("%sv1/account/pin/unlock", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			pin = p2
		})
	})
end
