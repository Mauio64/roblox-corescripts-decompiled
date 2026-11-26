local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetResultsListFocusedWidget", function(p2, p3, data)
	module.isTypeOrNil(p3, "string", "focusedWidgetId expects widget.id")
	module.isNotNil(data, "focusedWidgetTemplate")

	return {
		searchUuid = p2,
		id = p3,
		title = data.title,
		description = data.description,
		localizedTitle = data.localizedTitle,
		localizedDescription = data.localizedDescription,
		localizedTooltip = data.localizedTooltip,
		tooltip = data.tooltip
	}
end)
