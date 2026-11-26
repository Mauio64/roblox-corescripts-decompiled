return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("SetUserTyping", function(p2, p3, p4)
	return { conversationId = p2, userId = p3, value = p4 }
end)
