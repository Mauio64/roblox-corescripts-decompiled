local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("SetLookFavorite", function(p2, p3)
	module.isType(p2, "string", "SetLookFavorite expects lookId")
	module.isType(p3, "boolean", "SetLookFavorite expects isFavorited")

	return { lookId = p2, isFavorited = p3 }
end)
