local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_MENU_OPEN", function(p1) -- line: 5
	return {
		isMenuOpen = p1
	}
end)
