return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux").makeActionCreator("NavigateIntoChat", function(p2)
	return { screen = p2.screen, params = p2.params }
end)
