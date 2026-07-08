return require(script.Parent.Parent.ActionCreator)("SetPlayerIsLocalPlayer", function(p1, p2) -- line: 4
	return {
		player = p1,
		userId = p1.UserId,
		isLocalPlayer = p2
	}
end)
