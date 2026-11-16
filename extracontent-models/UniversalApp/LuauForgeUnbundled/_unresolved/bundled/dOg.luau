local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

return Rodux.makeActionCreator("RevokeOutfit", function(p2)
	return { outfitId = tostring(p2) }
end)
