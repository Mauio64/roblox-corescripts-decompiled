local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dMc")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetOutfitInfo", function(p2)
	return { outfit = p2 }
end)
