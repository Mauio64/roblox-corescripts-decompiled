local module = require("@luauforge/bundled/fHo")
local module2 = require("@luauforge/bundled/fHs")

return {
	create = module.create,
	createRequests = module2.create,
	isDesktopBrowserSignInEnabled = require("@luauforge/bundled/fHx"),
	Flags = { FFlagGoogleAppleSsoDesktop = require("@luauforge/bundled/fHy") }
}
