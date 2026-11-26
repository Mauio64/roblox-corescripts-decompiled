local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("OutfitInformationReceived", function(p2)
	return { outfits = p2 }
end)
