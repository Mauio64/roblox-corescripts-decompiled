local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_MORE_MENU_OPEN", function(p1) -- line: 5
	return {
		isMainPageMoreMenuOpen = p1
	}
end)
