return require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Rodux").makeActionCreator("SetUserGameVotes", function(value, p2, value2, value3)
	assert(type(value) == "string", "SetUserGameVotes: universeId must be a string")
	assert(type(p2) == "boolean", "SetUserGameVotes: canVote must be a boolean")
	assert(type(value2) == "string", "SetUserGameVotes: userVote must be a string")
	assert(type(value3) == "string", "SetUserGameVotes: reasonForNotVoteable must be a string")

	return {
		universeId = value,
		canVote = p2,
		userVote = value2,
		reasonForNotVoteable = value3
	}
end)
