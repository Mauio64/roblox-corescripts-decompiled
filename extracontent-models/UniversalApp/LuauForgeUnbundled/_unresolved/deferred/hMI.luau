local module = require("@luauforge/deferred/hMJ")

return function(p2)
	return function(p3)
		return module(p2)
	end
end
