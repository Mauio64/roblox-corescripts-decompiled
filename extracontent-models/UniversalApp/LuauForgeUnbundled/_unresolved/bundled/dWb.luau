local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPE")

return Rodux.makeActionCreator("SetUnavailableItemFilter", function(p2)
	return { unavailableItemFilter = p2 }
end)
