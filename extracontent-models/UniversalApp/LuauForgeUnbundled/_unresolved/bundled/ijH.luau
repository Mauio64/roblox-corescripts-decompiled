local module = require("@luauforge/bundled/dVn")

return function(callback, value)
	assert(type(value) == "string", "GameGetIsFavorite request expects universeId to be a string")

	return callback(string.format("%sv1/games/%s/favorites", module.GAME_URL, value), "GET")
end
