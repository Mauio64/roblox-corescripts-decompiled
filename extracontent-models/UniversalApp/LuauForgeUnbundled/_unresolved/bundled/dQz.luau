local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dPs")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetBundleOwned", function(p2, p3)
	return { bundleId = p2, isOwned = p3 }
end)
