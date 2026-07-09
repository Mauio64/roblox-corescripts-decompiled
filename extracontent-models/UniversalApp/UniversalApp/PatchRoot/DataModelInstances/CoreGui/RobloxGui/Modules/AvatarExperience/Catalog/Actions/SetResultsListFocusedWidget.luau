local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, t1: {[any]: any}) -- line: 17
	-- upvalues: ArgCheck (copy)
	ArgCheck.isTypeOrNil(s2, "string", "focusedWidgetId expects widget.id")
	ArgCheck.isNotNil(t1, "focusedWidgetTemplate")

	return {
		searchUuid = s1,
		id = s2,
		title = t1.title,
		description = t1.description,
		localizedTitle = t1.localizedTitle,
		localizedDescription = t1.localizedDescription,
		localizedTooltip = t1.localizedTooltip,
		tooltip = t1.tooltip
	}
end)
