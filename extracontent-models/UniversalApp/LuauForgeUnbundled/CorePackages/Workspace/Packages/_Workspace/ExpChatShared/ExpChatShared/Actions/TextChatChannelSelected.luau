return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("TextChatChannelSelected", function(p2, p3)
	return { channelName = p2, shouldReorderTabs = p3 }
end)
