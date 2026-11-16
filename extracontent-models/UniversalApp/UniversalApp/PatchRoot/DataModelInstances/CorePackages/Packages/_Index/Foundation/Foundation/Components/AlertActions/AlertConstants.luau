local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Icon = BuilderIcons.Icon

local AlertSeverity = require(Foundation.Enums.AlertSeverity)

require(Foundation.Enums.ButtonVariant)

return {
	MAX_ACTION_COUNT = 3,
	SEVERITY_TO_ICON = {
		[AlertSeverity.Info] = Icon.CircleI,
		[AlertSeverity.Warning] = Icon.TriangleExclamation,
		[AlertSeverity.Success] = Icon.CircleCheck,
		[AlertSeverity.Error] = Icon.CircleX
	}
}
