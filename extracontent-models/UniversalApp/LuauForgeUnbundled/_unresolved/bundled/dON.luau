local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dMc")
require("@luauforge/bundled/dHL")

return Rodux.makeActionCreator("SetOutfitOrAsset", function(p2, p3)
	return { ids = p2, itemType = p3 }
end)
