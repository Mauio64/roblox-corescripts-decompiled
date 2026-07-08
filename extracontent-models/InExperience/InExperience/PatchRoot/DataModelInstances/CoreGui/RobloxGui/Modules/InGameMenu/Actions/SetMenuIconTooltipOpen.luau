local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_MENU_ICON_TOOLTIP_OPEN", function(p1) -- line: 5
	return {
		menuIconTooltipOpen = p1
	}
end)
