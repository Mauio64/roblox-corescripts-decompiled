local Parent = script:FindFirstAncestor("GameVotesRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 18
	-- upvalues: Url (copy)
	assert(type(p2) == "string", "GetGameVotes request expects universeId to be a string")

	return p1(string.format("%sv1/games/%s/votes", Url.GAME_URL, p2), "GET")
end
