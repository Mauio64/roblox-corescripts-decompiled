local parent = script:FindFirstAncestor("GameInfosRodux").Parent

local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(games)
	assert(type(games) == "table", string.format("AddGames action expects games to be a table, was %s", (type(games))))

	return { games = games }
end)
