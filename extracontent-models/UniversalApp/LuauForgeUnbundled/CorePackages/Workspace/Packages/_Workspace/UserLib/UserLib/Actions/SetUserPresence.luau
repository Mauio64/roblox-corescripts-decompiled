return require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Rodux").makeActionCreator("SetUserPresence", function(p2, p3, p4)
	return { userId = tostring(p2), presence = p3, lastLocation = p4 }
end)
