local module = require("@luauforge/deferred/fEH")
local module2 = require("@luauforge/deferred/fEJ")
local module3 = require("@luauforge/deferred/fFG")

local function displayRestyleDisconnectDialog(onSecondaryActivated, p2)
	local displayDialog = module2.displayDialog

	local v6 = if not module3() then module.Enums.ColorMode.Dark else nil
	displayDialog({
		kind = "dialog",
		title = p2 and "Your time in Restyle has ended" or "Something went wrong with Restyle",
		body = "Thanks for being one of the first to try it.",
		secondaryActionText = "Leave",
		onSecondaryActivated = onSecondaryActivated,
		colorMode = v6
	})
end

return displayRestyleDisconnectDialog
