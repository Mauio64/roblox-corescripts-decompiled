local Parent = script:FindFirstAncestor("GameVotesRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 19
	-- upvalues: Url (copy)
	assert(type(p2) == "string", "GetUserGameVotes request expects universeId to be a string")

	return p1(string.format("%sv1/games/%s/votes/user", Url.GAME_URL, p2), "GET")
end
