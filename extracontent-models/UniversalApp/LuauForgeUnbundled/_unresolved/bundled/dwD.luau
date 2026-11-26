local url = require("@luauforge/bundled/dus").Url

return function(callback, value)
	assert(typeof(value) == "string", "universe has to be a string")

	return callback(string.format("%sv2/games/%s/media", url.GAME_URL, value), "GET")
end
