local module = require("@luauforge/deferred/fEH")
local module2 = require("@luauforge/deferred/fEJ")
local module3 = require("@luauforge/deferred/fFG")

local function displayDisconnectDialog(onPrimaryActivated, onSecondaryActivated)
	local displayDialog = module2.displayDialog

	local v6 = if not module3() then module.Enums.ColorMode.Dark else nil
	displayDialog({
		kind = "dialog",
		title = "Cloud Play stopped working",
		body = "Rejoin the game to keep playing without Cloud Play.",
		primaryActionText = "Play",
		secondaryActionText = "Leave",
		onPrimaryActivated = onPrimaryActivated,
		onSecondaryActivated = onSecondaryActivated,
		colorMode = v6
	})
end

return displayDisconnectDialog
