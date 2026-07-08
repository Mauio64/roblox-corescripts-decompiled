return require(script.Parent.Parent.ActionCreator)("SetPlayerIsFollowing", function(p1, p2) -- line: 4
	return {
		player = p1,
		userId = p1.UserId,
		isFollowing = p2
	}
end)
