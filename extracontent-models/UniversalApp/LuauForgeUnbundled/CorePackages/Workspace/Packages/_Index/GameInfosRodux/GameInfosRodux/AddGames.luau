local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/Rodux").makeActionCreator
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DiscoveryTypes")

return makeActionCreator("AddGames", function(p2)
	assert(
		type(p2) == "table",
		string.format("AddGames action expects games to be a table, was %s", (type(p2)))
	)

	return { games = p2 }
end)
