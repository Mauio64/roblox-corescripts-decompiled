local parent = script:FindFirstAncestor("GameProductInfoRodux").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, list)
	assert(type(list) == "table", "GamesGetProductInfo request expects universeIds to be a table")
	assert(#list > 0, "GamesGetProductInfo request expects universeIds count to be greater than 0")
	assert(#list <= 100, "GamesGetProductInfo request expects universeIds count to not exceed " .. 100)

	local joined = table.concat(list, ",")
	return callback(string.format("%sv1/games/games-product-info?universeIds=%s", Url.GAME_URL, joined), "GET")
end
