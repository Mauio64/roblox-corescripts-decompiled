local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("SetOrder", function(p2)
	return { assetIdToOrderAndAssetTypeId = p2 }
end)
