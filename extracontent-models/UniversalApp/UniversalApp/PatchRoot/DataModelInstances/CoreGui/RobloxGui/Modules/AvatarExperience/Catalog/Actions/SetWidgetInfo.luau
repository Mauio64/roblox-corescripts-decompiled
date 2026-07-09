local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

return Rodux.makeActionCreator(script.Name, function(p1, p2, p3, p4, p5) -- line: 29
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetWidgetInfo expects widgetInfo")

	return {
		widgetInfo = p1,
		requestId = p2,
		query = p3,
		context = p4,
		configuration = p5
	}
end)
