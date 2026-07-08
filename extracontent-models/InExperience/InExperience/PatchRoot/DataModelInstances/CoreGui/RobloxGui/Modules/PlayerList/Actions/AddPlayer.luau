return require(script.Parent.Parent.ActionCreator)("AddPlayer", function(p1) -- line: 4
	return {
		player = p1,
		userId = p1.UserId
	}
end)
