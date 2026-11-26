return require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Rodux").makeActionCreator("ReceivedDisplayName", function(p2, p3)
	return { userId = tostring(p2), displayName = p3 }
end)
