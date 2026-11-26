local module = require("@luauforge/bundled/ehl")
local module2 = require("@luauforge/bundled/ehm")

return function(p2)
	return function(object)
		object:dispatch(module2(module.DiscoverabilityUpsell, p2))
	end
end
