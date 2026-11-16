local module = require("@luauforge/deferred/ghw")
local module2 = require("@luauforge/bundled/dOH")

return function()
	return function(object)
		object:dispatch(module2((module(object:getState()))))
	end
end
