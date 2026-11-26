local module = require("@luauforge/bundled/ehl")
local module2 = require("@luauforge/bundled/ehm")
local module3 = require("@luauforge/bundled/dFu")
local module4 = require("@luauforge/bundled/dKv")

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
