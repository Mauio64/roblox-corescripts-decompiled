local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("DECREMENT_CONTROLLER_BAR_COUNT", function()
	return {}
end)
