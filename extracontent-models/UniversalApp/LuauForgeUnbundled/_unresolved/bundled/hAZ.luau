local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")

return function(p2)
	return function(object)
		object:dispatch(module2(module.VerifyPhoneNumber, p2))
	end
end
