return require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux").makeActionCreator("CurrentSquadUpdated", function(p2)
	return {
		payload = { squad = p2 }
	}
end)
