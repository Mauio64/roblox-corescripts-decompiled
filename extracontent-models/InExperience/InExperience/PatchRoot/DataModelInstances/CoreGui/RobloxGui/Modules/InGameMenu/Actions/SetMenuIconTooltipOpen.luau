local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_MENU_ICON_TOOLTIP_OPEN", function(menuIconTooltipOpen)
	return { menuIconTooltipOpen = menuIconTooltipOpen }
end)
