local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

return function(p1) -- line: 18
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.usermoderation.reminder(), "GET")
end
