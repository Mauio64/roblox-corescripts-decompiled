local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

return Rodux.makeActionCreator("OutfitRenamed", function(p2, p3)
	return { outfitId = p2, name = p3 }
end)
