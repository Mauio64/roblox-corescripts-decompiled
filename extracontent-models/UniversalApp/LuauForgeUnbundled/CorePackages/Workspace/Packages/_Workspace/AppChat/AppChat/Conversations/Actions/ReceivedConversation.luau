return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("ReceivedConversation", function(p2)
	return { conversation = p2 }
end)
