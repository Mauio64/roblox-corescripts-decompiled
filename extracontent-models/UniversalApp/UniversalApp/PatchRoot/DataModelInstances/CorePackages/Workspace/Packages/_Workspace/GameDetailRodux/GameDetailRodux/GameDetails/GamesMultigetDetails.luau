local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 18
	-- upvalues: Url (copy)
	assert(type(p2) == "table", "GamesMultigetDetails request expects universeIds to be a table")

	if #p2 == 0 or #p2 > 100 then
		error("GamesMultigetDetails request expects universeIds count between 1-100")
	end

	local v5 = table.concat(p2, ",")

	return p1(string.format("%sv1/games?universeIds=%s", Url.GAME_URL, v5), "GET")
end
