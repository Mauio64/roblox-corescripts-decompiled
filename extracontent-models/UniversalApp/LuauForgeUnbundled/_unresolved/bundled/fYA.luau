local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value)
	assert(type(value) == "string", "GameGetIsFavorite request expects universeId to be a string")

	return callback(string.format("%sv1/games/%s/favorites", Url.GAME_URL, value), "GET")
end
