local parent = script:FindFirstAncestor("GameVotesRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(universeId, value, value2)
	assert(type(universeId) == "string", "SetGameVotes: universeId must be a string")
	assert(type(value) == "number", "SetGameVotes: upVotes must be a number")
	assert(type(value2) == "number", "SetGameVotes: downVotes must be a number")

	return { universeId = universeId, upVotes = value, downVotes = value2 }
end)
