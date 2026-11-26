local module = require("@luauforge/bundled/ieX")

local module2 = require("@luauforge/bundled/ifa")

return {
	CaptionButtonPressed = {
		eventName = "CustomTitleBar_CaptionButtonPressed",
		backends = { module.TelemetryBackends.Counter },
		lastUpdated = { 2026, 8, 19 },
		throttlingPercentage = module2,
		description = "Counter fired when a caption button is pressed. The \"action\" field distinguishes Minimize, Maximize, Restore, and Close.",
		links = ""
	},
	DragAreaInteraction = {
		eventName = "CustomTitleBar_DragAreaInteraction",
		backends = { module.TelemetryBackends.Counter },
		lastUpdated = { 2026, 8, 19 },
		throttlingPercentage = module2,
		description = "Counter fired on drag-area interactions. The \"action\" field distinguishes DragBegan, DoubleClicked, and RightClicked.",
		links = ""
	}
}
