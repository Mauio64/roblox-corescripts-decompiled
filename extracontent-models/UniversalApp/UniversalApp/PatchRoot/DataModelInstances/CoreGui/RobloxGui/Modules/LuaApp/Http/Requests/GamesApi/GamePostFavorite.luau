local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2, p3) -- line: 14
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "string", "GamePostFavorite request expects universeId to be a string")
	assert(type(p3) == "boolean", "GamePostFavorite request expects isFavorited to be a boolean")

	return p1(string.format("%sv1/games/%s/favorites", Url.GAME_URL, p2), "POST", {
		postBody = HttpService:JSONEncode({
			isFavorited = p3
		})
	})
end
