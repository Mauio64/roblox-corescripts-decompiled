local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")
require("@luauforge/bundled/dKU")

return Rodux.makeActionCreator("SetAssetResaleData", function(p2, p3)
	module.isType(p2, "string", "assetId")
	module.isType(p3, "table", "assetResaleData")
	return { assetId = p2, assetResaleData = p3 }
end)
