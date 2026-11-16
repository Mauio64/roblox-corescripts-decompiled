local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/bundled/ecW")

return function(p2)
	return function(object)
		return object:dispatch(p2):andThen(function(p3)
			return module.resolve(p3)
		end, function(p3)
			object:dispatch(module2(p3))
			return module.reject(p3)
		end)
	end
end
