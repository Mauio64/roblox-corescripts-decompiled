return require(script.Parent.Parent.ActionCreator)("SetPlayerIsCreator", function(p1, p2) -- line: 4
	return {
		player = p1,
		userId = p1.UserId,
		isCreator = p2
	}
end)
