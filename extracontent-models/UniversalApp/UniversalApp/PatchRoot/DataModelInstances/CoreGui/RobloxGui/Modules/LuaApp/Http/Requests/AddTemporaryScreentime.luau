local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 7
	-- upvalues: Url (copy), HttpService (copy)
	return p1(Url.APIS_URL .. "parental-controls-api/v1/parental-controls/add-temporary-screentime", "POST", {
		postBody = HttpService:JSONEncode({
			minutes = p2
		})
	})
end
