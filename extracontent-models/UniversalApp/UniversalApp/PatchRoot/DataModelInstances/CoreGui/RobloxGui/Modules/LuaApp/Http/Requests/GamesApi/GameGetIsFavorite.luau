local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 16
	-- upvalues: Url (copy)
	assert(type(p2) == "string", "GameGetIsFavorite request expects universeId to be a string")

	return p1(string.format("%sv1/games/%s/favorites", Url.GAME_URL, p2), "GET")
end
