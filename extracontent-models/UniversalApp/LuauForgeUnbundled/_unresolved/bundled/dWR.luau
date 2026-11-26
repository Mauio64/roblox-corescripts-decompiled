local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetSelectedAccessory", function(p2)
	return { selectedAccessory = p2 }
end)
