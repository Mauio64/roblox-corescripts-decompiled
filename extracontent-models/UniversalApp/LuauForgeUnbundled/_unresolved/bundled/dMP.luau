local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
require("@luauforge/bundled/dHL")

return Rodux.makeActionCreator("SetHydratedWidgetData", function(p2)
	module.isType(p2, "table", "payload")
	return { payload = p2 }
end)
