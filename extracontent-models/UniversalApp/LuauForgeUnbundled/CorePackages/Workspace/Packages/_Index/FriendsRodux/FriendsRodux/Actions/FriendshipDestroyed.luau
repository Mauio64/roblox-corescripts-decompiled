return require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux").makeActionCreator("FriendshipDestroyed", function(p2, p3)
	return {
		payload = { userId1 = p2, userId2 = p3 }
	}
end)
