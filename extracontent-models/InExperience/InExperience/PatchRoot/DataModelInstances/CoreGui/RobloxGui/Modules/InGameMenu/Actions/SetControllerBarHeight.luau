local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_CONTROLLER_BAR_HEIGHT", function(p1) -- line: 5
	return {
		controllerBarHeight = p1
	}
end)
