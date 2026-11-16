return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("CurrentConversationTimeoutEnded", function(p2)
	return { conversationId = p2 }
end)
