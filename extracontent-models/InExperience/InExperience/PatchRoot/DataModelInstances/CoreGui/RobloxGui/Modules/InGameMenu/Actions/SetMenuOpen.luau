local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_MENU_OPEN", function(isMenuOpen)
	return { isMenuOpen = isMenuOpen }
end)
