local module = require("@luauforge/bundled/dVn")

return function(callback, p2)
	return callback(
		string.format(
			"%sgame-passes/v1/universes/%s/game-passes?pageSize=50&passView=Full",
			module.APIS_URL,
			p2
		),
		"GET"
	)
end
