local Parent = script:FindFirstAncestor("GameProductInfoRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 26
	-- upvalues: Url (copy)
	assert(type(p2) == "table", "GamesGetProductInfo request expects universeIds to be a table")
	assert(#p2 > 0, "GamesGetProductInfo request expects universeIds count to be greater than 0")
	assert(#p2 <= 100, "GamesGetProductInfo request expects universeIds count to not exceed " .. 100)

	local v5 = table.concat(p2, ",")

	return p1(string.format("%sv1/games/games-product-info?universeIds=%s", Url.GAME_URL, v5), "GET")
end
