local module = require("@luauforge/bundled/hMW")
require("@luauforge/bundled/hMS")

return module.createContext({
	activationFrameworkState = {},
	dispatch = nil,
	navigation = nil
})
