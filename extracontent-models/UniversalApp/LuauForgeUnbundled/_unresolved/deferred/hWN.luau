local module = require("@luauforge/bundled/egt")

local module2 = require("@luauforge/deferred/hWO")

return function(p2, p3, p4, p5)
	return function(object)
		return module2(p2, p3, p4, p5):andThen(nil, function(p6)
			object:dispatch(module(p6))
		end)
	end
end
