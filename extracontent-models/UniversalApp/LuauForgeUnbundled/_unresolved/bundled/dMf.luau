local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

return Rodux.makeActionCreator("UpdateLookDetails", function(p2, p3)
	return { lookId = p2, lookDetails = p3 }
end)
