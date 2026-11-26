local module = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Stores/GetTransientUIOverlayStore")
require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Types")

return {
	GetTransientUIOverlayStore = module,
	OverlayScreen = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/OverlayScreen"),
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
