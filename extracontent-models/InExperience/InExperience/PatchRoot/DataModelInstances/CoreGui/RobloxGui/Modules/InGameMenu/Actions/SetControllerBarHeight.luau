local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_CONTROLLER_BAR_HEIGHT", function(controllerBarHeight)
	return { controllerBarHeight = controllerBarHeight }
end)
