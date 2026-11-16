local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

require("@luauforge/bundled/dMc")

return Rodux.makeActionCreator("SetAssetInfoFromInventoryOutfitDetails", function(p2)
	module.isType(p2, "table", "SetAssetInfoFromInventoryOutfitDetails action expects assets to be a table")

	return { assets = p2 }
end)
