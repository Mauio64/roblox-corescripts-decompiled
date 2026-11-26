local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("RemoveNewAssetNotification", function(p2)
	return { assetTypeId = p2 }
end)
