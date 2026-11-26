local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")
require("@luauforge/bundled/dKU")

return Rodux.makeActionCreator("SetAssetLowestPrice", function(p2, p3)
	module.isType(p2, "string", "assetId")
	module.isType(p3, "number", "priceInRobux")

	return { assetId = p2, priceInRobux = p3 }
end)
