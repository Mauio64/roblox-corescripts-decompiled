return require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux").makeActionCreator("SelfPermissionUpdated", function(p2)
	return {
		payload = { selfPermissions = p2 }
	}
end)
