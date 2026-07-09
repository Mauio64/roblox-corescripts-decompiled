local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 6
	-- upvalues: Url (copy)
	return p1(Url.APIS_URL .. "identity-verification-service/v1/vietnam/validate-verification-form-status", "POST")
end
