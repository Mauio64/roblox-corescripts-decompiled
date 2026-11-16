local module = require("@luauforge/deferred/fxF")

local function displayDisconnectDialog(onPrimaryActivated, onSecondaryActivated)
	module.displayDialog({
		kind = "dialog",
		title = "Cloud Play stopped working",
		body = "Rejoin the game to keep playing without Cloud Play.",
		primaryActionText = "Play",
		secondaryActionText = "Leave",
		onPrimaryActivated = onPrimaryActivated,
		onSecondaryActivated = onSecondaryActivated
	})
end

return displayDisconnectDialog
