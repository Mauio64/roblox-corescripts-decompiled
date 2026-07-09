local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2, p3) -- line: 50
	-- upvalues: Url (copy)
	assert(type(p2) == "string", "GameGetRecommendedGames request expects universeId to be a string")

	local v6 = Url:makeQueryString(p3)

	return p1(string.format("%sv1/games/recommendations/game/%s?%s", Url.GAME_URL, p2, v6), "GET")
end
