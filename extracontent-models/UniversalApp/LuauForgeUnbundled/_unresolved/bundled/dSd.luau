local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dKU")

return Rodux.makeActionCreator("SetOutfitOrAsset", function(p2, p3)
	return { ids = p2, itemType = p3 }
end)
