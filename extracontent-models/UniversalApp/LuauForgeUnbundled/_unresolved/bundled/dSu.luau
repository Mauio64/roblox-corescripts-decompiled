local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("SetRemoteUprankedItems", function(p2)
	return { uprankedItems = p2 }
end)
