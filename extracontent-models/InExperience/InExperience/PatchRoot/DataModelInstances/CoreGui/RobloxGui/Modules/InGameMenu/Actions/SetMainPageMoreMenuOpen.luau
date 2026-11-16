local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_MORE_MENU_OPEN", function(isMainPageMoreMenuOpen)
	return { isMainPageMoreMenuOpen = isMainPageMoreMenuOpen }
end)
