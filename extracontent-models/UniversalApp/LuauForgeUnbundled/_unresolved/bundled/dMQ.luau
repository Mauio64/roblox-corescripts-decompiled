local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
require("@luauforge/bundled/dHL")

return Rodux.makeActionCreator("AppendAssetResellersList", function(p2, p3)
	module.isType(p2, "string", "assetId")
	module.isType(p3, "table", "userAssetIds")

	return { assetId = p2, userAssetIds = p3 }
end)
