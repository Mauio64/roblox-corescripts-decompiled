local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("GrantAsset", function(p2, p3)
	return { assetTypeId = p2, assetId = p3 }
end)
