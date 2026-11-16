local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

return Rodux.makeActionCreator("RemoveWidgetInfo", function(p2)
	module.isType(p2, "string", "RemoveWidgetInfo expects widgetId")

	return { widgetId = p2 }
end)
