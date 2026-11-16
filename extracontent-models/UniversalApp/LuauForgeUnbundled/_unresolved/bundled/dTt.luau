local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetAdjustmentType", function(p2)
	return { adjustmentType = p2 }
end)
