local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")

return function(p2, p3, p4, p5)
	return function(object)
		object:dispatch(module2(module.PurchaseGameRobuxShortfall, {
			gameName = p2,
			robuxShortfall = p3,
			theme = p4,
			pageFilter = p5
		}))
	end
end
