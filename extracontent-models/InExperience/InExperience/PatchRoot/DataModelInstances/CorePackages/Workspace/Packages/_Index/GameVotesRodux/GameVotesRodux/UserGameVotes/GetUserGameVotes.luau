local parent = script:FindFirstAncestor("GameVotesRodux").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, value)
	assert(type(value) == "string", "GetUserGameVotes request expects universeId to be a string")

	return callback(string.format("%sv1/games/%s/votes/user", Url.GAME_URL, value), "GET")
end
