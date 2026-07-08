return require(script.Parent.Parent.ActionCreator)("AddPlayerToTeam", function(p1, p2) -- line: 4
	return {
		player = p1,
		userId = p1.UserId,
		team = p2
	}
end)
