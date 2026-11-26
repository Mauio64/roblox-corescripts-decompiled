local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetPageFinished", function(p2, p3)
	return { assetTypeId = p2, isFinished = p3 }
end)
