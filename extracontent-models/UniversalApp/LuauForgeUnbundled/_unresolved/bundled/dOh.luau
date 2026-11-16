local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

return Rodux.makeActionCreator("UpdateOutfit", function(p2, p3, p4)
	return { outfitId = tostring(p2), isEditable = p3, outfitType = p4 }
end)
