local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("AddRemovedItem", function(p2, p3)
	return { removedAssetId = p2, removedAssetTypeId = p3 }
end)
