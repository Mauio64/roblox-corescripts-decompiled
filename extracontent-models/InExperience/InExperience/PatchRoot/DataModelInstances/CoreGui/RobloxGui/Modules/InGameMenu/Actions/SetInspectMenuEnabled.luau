local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_INSPECT_MENU_ENABLED", function(p1) -- line: 5
	return {
		enabled = p1
	}
end)
