return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("PlayerRemoved", function(p2)
	return { userId = tostring(p2) }
end)
