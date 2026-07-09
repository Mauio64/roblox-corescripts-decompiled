local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 19
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/games/%d/social-links/list", Url.GAME_URL, p2), "GET")
end
