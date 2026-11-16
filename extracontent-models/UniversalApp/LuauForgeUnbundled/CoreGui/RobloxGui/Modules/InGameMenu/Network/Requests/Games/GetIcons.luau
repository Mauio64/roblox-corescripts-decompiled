local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(string.format("%sv1/games/%d/social-links/list", Url.GAME_URL, p2), "GET")
end
