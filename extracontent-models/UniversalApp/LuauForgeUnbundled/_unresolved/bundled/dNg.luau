local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dMc")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetRecommendedBundlesAction", function(p2, p3, p4)
	return { bundleId = p2, bundleTypeId = p3, recommendedItems = p4 }
end)
