local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetAssetInfoFromBundleItemAction", function(p2)
	return { assets = p2 }
end)
