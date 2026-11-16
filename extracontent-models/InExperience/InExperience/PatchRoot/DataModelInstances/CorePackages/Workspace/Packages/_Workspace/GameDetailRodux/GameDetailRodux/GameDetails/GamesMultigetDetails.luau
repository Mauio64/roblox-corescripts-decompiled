local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, list)
	assert(type(list) == "table", "GamesMultigetDetails request expects universeIds to be a table")

	if #list == 0 or #list > 100 then
		error("GamesMultigetDetails request expects universeIds count between 1-100")
	end

	local joined = table.concat(list, ",")
	return callback(string.format("%sv1/games?universeIds=%s", Url.GAME_URL, joined), "GET")
end
