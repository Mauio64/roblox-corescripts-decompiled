local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetBundleFavorite", function(p2, p3)
	module.isType(p2, "string", "SetBundleFavorite expects bundleId")
	module.isType(p3, "boolean", "SetBundleFavorite expects isFavorited")

	return { bundleId = p2, isFavorited = p3 }
end)
