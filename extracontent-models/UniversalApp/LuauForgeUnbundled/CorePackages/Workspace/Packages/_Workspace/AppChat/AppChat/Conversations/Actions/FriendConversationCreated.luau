return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("FriendConversationCreated", function(p2)
	return {
		newConversationId = p2.newConversationId,
		oldFriendConversationId = p2.oldFriendConversationId
	}
end)
