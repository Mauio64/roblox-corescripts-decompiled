local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")

return Rodux.makeActionCreator("SetAssetOwned", function(p2, p3)
	return { assetId = p2, isOwned = p3 }
end)
