local module = require("@luauforge/bundled/fCE")

require("@luauforge/bundled/fFr")

return module.createContext({
	state = {},
	dispatch = nil,
	parentNavigation = nil,
	showLoginModalization = false,
	isPageVisible = true,
	eventOrigin = nil
})
