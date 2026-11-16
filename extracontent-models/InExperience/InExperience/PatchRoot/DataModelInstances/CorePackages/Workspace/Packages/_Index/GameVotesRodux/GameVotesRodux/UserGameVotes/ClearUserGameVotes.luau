local parent = script:FindFirstAncestor("GameVotesRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(universeId)
	assert(type(universeId) == "string", "ClearUserGameVotes: universeId must be a string")

	return { universeId = universeId }
end)
