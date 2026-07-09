local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 32
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/universes/%d/badges", Url.BADGES_URL, p2), "GET")
end
