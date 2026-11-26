local module = require("@luauforge/bundled/ggX")

require("@luauforge/bundled/gjL")

return module.createContext({
	state = {},
	dispatch = nil,
	parentNavigation = nil,
	showLoginModalization = false,
	isPageVisible = true,
	eventOrigin = nil
})
