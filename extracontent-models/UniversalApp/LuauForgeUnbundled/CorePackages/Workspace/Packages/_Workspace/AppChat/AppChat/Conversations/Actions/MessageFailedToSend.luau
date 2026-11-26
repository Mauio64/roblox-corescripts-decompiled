return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("MessageFailedToSend", function(p2, p3)
	return { conversationId = p2, messageId = p3 }
end)
