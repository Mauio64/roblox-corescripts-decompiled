local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("EquipOutfit", function(p2, p3)
	return { assets = p2, fullReset = p3 }
end)
