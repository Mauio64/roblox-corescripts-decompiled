local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

return Rodux.makeActionCreator("SetAssetIsPlusExclusive", function(p2, p3)
	return { assetId = p2, isPlusExclusive = p3 }
end)
