local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value, p2)
	assert(type(value) == "string", "GameGetRecommendedGames request expects universeId to be a string")

	local queryString = Url:makeQueryString(p2)
	return callback(
		string.format("%sv1/games/recommendations/game/%s?%s", Url.GAME_URL, value, queryString),
		"GET"
	)
end
