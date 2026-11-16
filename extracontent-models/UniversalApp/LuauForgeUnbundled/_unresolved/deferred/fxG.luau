local module = require("@luauforge/deferred/fxH")
require("@luauforge/deferred/fxK")

return {
	GetTransientUIOverlayStore = module,
	OverlayScreen = require("@luauforge/deferred/fxL"),
	displayDialog = function(p2)
		module(false).displayDialog(p2)
	end,
	displaySnackbar = function(p2, p3)
		module(false).displaySnackbar(p2, p3)
	end,
	clearDialog = function()
		module(false).clearDialog()
	end,
	clearSnackbar = function()
		module(false).clearSnackbar()
	end
}
