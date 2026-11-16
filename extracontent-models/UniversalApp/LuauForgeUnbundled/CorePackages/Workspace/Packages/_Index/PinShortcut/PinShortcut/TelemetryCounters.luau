local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/PinShortcut/LoggingProtocol")

local defineFastInt = game:DefineFastInt("PinShortcutSnackbarTelemetryThrottleHundredthsPercent", 0)

return {
	SnackbarButtonPressed = {
		eventName = "PinShortcut_SnackbarButtonPressed",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 17 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when a snackbar action button is pressed. The \"action\" field distinguishes TryAgain and ViewShortcut.",
		links = ""
	},
	SnackbarShown = {
		eventName = "PinShortcut_SnackbarShown",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 17 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the pin-experience result snackbar is displayed. The \"action\" field distinguishes Success, Failure, and AlreadyExists.",
		links = ""
	}
}
