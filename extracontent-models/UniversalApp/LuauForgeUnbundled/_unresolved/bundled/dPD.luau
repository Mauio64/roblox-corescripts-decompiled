local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetAssetFavorite", function(p2, p3)
	module.isType(p2, "string", "SetAssetFavorite expects assetId")
	module.isType(p3, "boolean", "SetAssetFavorite expects isFavorited")

	return { assetId = p2, isFavorited = p3 }
end)
