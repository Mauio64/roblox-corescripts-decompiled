local Foundation = script:FindFirstAncestor("Foundation")
local AlertSeverity = require(Foundation.Enums.AlertSeverity)

require(Foundation.Enums.ButtonVariant)

local t1 = {
	[AlertSeverity.Info] = "circle-i",
	[AlertSeverity.Warning] = "triangle-exclamation",
	[AlertSeverity.Success] = "circle-check",
	[AlertSeverity.Error] = "circle-x"
}

return {
	MAX_ACTION_COUNT = 3,
	SEVERITY_TO_ICON = t1
}
