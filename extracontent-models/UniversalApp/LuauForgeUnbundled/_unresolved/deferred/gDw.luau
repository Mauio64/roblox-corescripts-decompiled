local module = require("@luauforge/bundled/dVn")

return function(callback, value)
	assert(
		type(value) == "string",
		"GameGetPrivateServersEnabled request expects universeId to be a string"
	)

	return callback(
		string.format("%sv1/private-servers/enabled-in-universe/%s", module.GAME_URL, value),
		"GET"
	)
end
