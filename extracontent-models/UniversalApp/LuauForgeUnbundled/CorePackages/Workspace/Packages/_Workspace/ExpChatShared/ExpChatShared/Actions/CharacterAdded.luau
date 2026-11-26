return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("CharacterAdded", function(p2, p3)
	return { userId = tostring(p2), character = p3 }
end)
