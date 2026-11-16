local module = require("@luauforge/bundled/dHq")

return function(p2, p3)
	return function(object)
		object:dispatch(module(p2, p3))
		object:flush()
	end
end
