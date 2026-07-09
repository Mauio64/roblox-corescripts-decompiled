local Parent = script:FindFirstAncestor("GameInfosRodux").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

return makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 9
	assert(type(t1) == "table", string.format("AddGames action expects games to be a table, was %s", (type(t1))))

	return {
		games = t1
	}
end)
