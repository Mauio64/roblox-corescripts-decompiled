local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("UpdateUserAssetPrice", function(p2, p3)
	module.isType(p2, "string", "userAssetId")
	module.isTypeOrNil(p3, "number", "priceInRobux")

	return { userAssetId = p2, priceInRobux = p3 }
end)
