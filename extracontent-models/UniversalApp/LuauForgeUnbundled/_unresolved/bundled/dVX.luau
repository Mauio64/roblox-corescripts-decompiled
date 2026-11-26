local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dPF")

return Rodux.makeActionCreator("SetSalesTypeFilter", function(p2)
	return { salesType = p2 }
end)
