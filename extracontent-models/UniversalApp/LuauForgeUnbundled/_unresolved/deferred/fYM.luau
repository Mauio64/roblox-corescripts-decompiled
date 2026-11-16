local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value)
	assert(
		type(value) == "string",
		"GameGetPrivateServersEnabled request expects universeId to be a string"
	)

	return callback(
		string.format("%sv1/private-servers/enabled-in-universe/%s", Url.GAME_URL, value),
		"GET"
	)
end
