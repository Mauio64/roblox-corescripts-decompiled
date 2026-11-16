return require("@game/CorePackages/Workspace/Packages/_Workspace/GameVotesRodux/Rodux").makeActionCreator("ClearUserGameVotes", function(value)
	assert(type(value) == "string", "ClearUserGameVotes: universeId must be a string")

	return { universeId = value }
end)
