return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("SendingMessage", function(p2, p3)
	return { conversationId = p2, message = p3 }
end)
