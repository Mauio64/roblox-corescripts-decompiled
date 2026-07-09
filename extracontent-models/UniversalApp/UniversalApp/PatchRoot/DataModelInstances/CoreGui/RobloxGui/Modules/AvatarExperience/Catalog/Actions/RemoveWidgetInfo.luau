local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 15
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "RemoveWidgetInfo expects widgetId")

	return {
		widgetId = p1
	}
end)
