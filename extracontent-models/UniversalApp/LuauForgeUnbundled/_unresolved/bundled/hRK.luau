local module = require("@luauforge/bundled/ehl")
local module2 = require("@luauforge/bundled/ehm")

return function(p2, p3)
	return function(object)
		object:dispatch(module2(module.ConfirmSignOut, { continueFunc = p2, theme = p3 }))
	end
end
