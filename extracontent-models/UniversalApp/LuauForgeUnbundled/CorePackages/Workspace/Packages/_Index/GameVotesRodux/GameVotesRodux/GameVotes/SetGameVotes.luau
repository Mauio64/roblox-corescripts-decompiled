return require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Rodux").makeActionCreator("SetGameVotes", function(value, value2, value3)
	assert(type(value) == "string", "SetGameVotes: universeId must be a string")
	assert(type(value2) == "number", "SetGameVotes: upVotes must be a number")
	assert(type(value3) == "number", "SetGameVotes: downVotes must be a number")

	return { universeId = value, upVotes = value2, downVotes = value3 }
end)
