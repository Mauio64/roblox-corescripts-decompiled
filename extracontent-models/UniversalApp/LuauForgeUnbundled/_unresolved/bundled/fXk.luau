local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(
		string.format(
			"%sgame-passes/v1/universes/%s/game-passes?pageSize=50&passView=Full",
			Url.APIS_URL,
			p2
		),
		"GET"
	)
end
