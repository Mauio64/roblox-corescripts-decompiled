local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_CONTROL_LAYOUT", function(controlLayout)
	return { controlLayout = controlLayout }
end)
