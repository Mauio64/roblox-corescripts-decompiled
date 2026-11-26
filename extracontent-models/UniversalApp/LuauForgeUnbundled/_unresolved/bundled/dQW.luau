local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

return Rodux.makeActionCreator("SetWidgetInfo", function(p2, p3, p4, p5, p6)
	module.isType(p2, "table", "SetWidgetInfo expects widgetInfo")

	return {
		widgetInfo = p2,
		requestId = p3,
		query = p4,
		context = p5,
		configuration = p6
	}
end)
