local module = require("@luauforge/bundled/ehm")
local module2 = require("@luauforge/bundled/ehl")

return function(p2, p3)
	return function(object)
		object:dispatch(module(module2.EconomicRestrictionPrompt, {
			failureReason = p2,
			expirationTimeInMinutes = p3
		}))
	end
end
