local module = require("@luauforge/bundled/hBF")
require("@luauforge/bundled/hBB")

return module.createContext({
	activationFrameworkState = {},
	dispatch = nil,
	navigation = nil
})
