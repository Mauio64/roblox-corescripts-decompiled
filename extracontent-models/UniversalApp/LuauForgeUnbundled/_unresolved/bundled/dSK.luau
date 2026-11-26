local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dSJ")

return Rodux.makeActionCreator("AppendUserInventoryRecommendations", function(p2, p3, p4)
	return { searchUuid = p2, sortResults = p3, forceUpdate = p4 }
end)
