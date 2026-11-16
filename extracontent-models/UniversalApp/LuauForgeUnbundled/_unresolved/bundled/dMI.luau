local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetAssetInfoFromOutfitDetails", function(p2, p3)
	module.isType(p2, "table", "SetAssetInfoFromOutfitDetails action expects assets to be a table")

	return { assets = p2, outfitModerationStatus = p3 }
end)
