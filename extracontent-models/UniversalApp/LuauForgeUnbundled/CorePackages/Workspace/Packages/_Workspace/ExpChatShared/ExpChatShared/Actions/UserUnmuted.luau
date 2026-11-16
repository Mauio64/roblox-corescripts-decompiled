return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("UserUnmuted", function(p2)
	return { userId = tostring(p2) }
end)
