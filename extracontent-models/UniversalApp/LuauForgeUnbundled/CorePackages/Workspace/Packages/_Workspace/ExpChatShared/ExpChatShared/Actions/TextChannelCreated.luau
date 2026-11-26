return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("TextChannelCreated", function(p2)
	return { textChannel = p2 }
end)
