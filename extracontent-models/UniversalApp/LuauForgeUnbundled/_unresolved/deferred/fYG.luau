local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(string.format("%sv1/universes/%d/badges", Url.BADGES_URL, p2), "GET")
end
