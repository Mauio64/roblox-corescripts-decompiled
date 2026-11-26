return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("TargetTextChannelPropertyChanged", function(p2, p3, p4)
	return { textChannel = p2, shouldReorderTabs = p3, isUserInitiated = p4 }
end)
