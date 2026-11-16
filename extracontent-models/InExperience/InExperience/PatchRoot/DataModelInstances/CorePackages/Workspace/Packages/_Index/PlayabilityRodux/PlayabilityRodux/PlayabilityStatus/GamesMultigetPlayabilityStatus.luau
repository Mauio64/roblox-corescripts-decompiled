local parent = script:FindFirstAncestor("PlayabilityRodux").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, list)
	assert(type(list) == "table", "GamesMultigetPlayabilityStatus request expects universeId to be a table")

	local joined = table.concat(list, ",")
	return callback(
		string.format("%s/v1/games/multiget-playability-status?universeIds=%s", Url.GAME_URL, joined),
		"GET"
	)
end
