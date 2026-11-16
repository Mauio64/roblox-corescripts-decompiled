local module = require("@luauforge/bundled/edP")
local module2 = require("@luauforge/bundled/edO")

return function(p2, p3)
	return function(object)
		object:dispatch(module(module2.EconomicRestrictionPrompt, {
			failureReason = p2,
			expirationTimeInMinutes = p3
		}))
	end
end
