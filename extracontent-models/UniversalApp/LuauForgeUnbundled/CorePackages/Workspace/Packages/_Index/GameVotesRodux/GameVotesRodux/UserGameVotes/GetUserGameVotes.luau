local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Http").Url

return function(callback, value)
	assert(type(value) == "string", "GetUserGameVotes request expects universeId to be a string")

	return callback(string.format("%sv1/games/%s/votes/user", url.GAME_URL, value), "GET")
end
