local HttpService = game:GetService("HttpService")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value, p2)
	assert(type(value) == "string", "GamePostFavorite request expects universeId to be a string")
	assert(type(p2) == "boolean", "GamePostFavorite request expects isFavorited to be a boolean")

	return callback(string.format("%sv1/games/%s/favorites", Url.GAME_URL, value), "POST", {
		postBody = HttpService:JSONEncode({ isFavorited = p2 })
	})
end
