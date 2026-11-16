local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("RemoveCurrentlySellingAsset", function(p2, p3)
	module.isType(p2, "string", "assetId")
	module.isType(p3, "string", "userAssetId")

	return { assetId = p2, userAssetId = p3 }
end)
