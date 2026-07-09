local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

return function(p1) -- line: 19
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.fromString("accountinformation:phone")(), "GET")
end
