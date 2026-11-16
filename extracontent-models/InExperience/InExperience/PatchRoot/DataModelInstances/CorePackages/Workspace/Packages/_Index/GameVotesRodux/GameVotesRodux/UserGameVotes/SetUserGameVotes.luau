local parent = script:FindFirstAncestor("GameVotesRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(universeId, canVote, value, value2)
	assert(type(universeId) == "string", "SetUserGameVotes: universeId must be a string")
	assert(type(canVote) == "boolean", "SetUserGameVotes: canVote must be a boolean")
	assert(type(value) == "string", "SetUserGameVotes: userVote must be a string")
	assert(type(value2) == "string", "SetUserGameVotes: reasonForNotVoteable must be a string")

	return {
		universeId = universeId,
		canVote = canVote,
		userVote = value,
		reasonForNotVoteable = value2
	}
end)
