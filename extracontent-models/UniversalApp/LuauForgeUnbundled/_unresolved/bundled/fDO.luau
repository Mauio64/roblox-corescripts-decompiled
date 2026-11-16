local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")
local module3 = require("@luauforge/bundled/dCp")
local module4 = require("@luauforge/bundled/dHq")

return function(object, onActivated)
	object:dispatch(module4({
		{ name = module3.Landing }
	}))
	object:dispatch(module2(module.AccountAuthenticationFailureOverlay, {
		onActivated = onActivated
	}, {
		DisableBackButtonClose = true
	}))
end
