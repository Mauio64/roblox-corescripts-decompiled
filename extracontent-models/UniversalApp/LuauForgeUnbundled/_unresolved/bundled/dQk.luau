local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")
require("@luauforge/bundled/dKU")

return Rodux.makeActionCreator("SetAssetVersionData", function(p2, p3)
	module.isType(p2, "string", "expect assetId to be a string")
	module.isType(p3, "table", "expect assetVersionData to be a table")

	return { assetId = p2, assetVersionData = p3 }
end)
