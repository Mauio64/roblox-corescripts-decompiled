local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetCurrentlySellingAssetsFromFetchSellData", function(p2, p3)
	module.isType(p2, "string", "assetId")
	module.isType(p3, "table", "userAssetIdList")

	return { assetId = p2, userAssetIdList = p3 }
end)
