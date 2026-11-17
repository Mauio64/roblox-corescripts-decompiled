local GetTransientUIOverlayStore = require(script.Stores.GetTransientUIOverlayStore)
require(script.Types)

return {
	["jest.config"] = script["jest.config"],
	GetTransientUIOverlayStore = GetTransientUIOverlayStore,
	OverlayScreen = require(script.OverlayScreen),
	displayDialog = function(p)
		GetTransientUIOverlayStore(false).displayDialog(p)
	end,
	displaySnackbar = function(p, p2: number)
		GetTransientUIOverlayStore(false).displaySnackbar(p, p2)
	end,
	clearDialog = function()
		GetTransientUIOverlayStore(false).clearDialog()
	end,
	clearSnackbar = function()
		GetTransientUIOverlayStore(false).clearSnackbar()
	end
}
