local module = require("@luauforge/bundled/glI")
local module2 = require("@luauforge/bundled/glM")

return {
	create = module.create,
	createRequests = module2.create,
	isDesktopBrowserSignInEnabled = require("@luauforge/bundled/glR"),
	Flags = { FFlagGoogleAppleSsoDesktop = require("@luauforge/bundled/glS") }
}
