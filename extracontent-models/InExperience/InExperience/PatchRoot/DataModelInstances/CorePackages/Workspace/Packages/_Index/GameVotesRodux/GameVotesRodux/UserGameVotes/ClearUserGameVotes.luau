local Parent = script:FindFirstAncestor("GameVotesRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	assert(type(p1) == "string", "ClearUserGameVotes: universeId must be a string")

	return {
		universeId = p1
	}
end)
