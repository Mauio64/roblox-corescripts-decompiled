local Parent = script:FindFirstAncestor("PlayabilityRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 22
	-- upvalues: Url (copy)
	assert(type(p2) == "table", "GamesMultigetPlayabilityStatus request expects universeId to be a table")

	local v5 = table.concat(p2, ",")

	return p1(string.format("%s/v1/games/multiget-playability-status?universeIds=%s", Url.GAME_URL, v5), "GET")
end
