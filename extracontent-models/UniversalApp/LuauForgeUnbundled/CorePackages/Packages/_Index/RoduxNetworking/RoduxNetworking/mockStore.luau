local module = require("@luauforge/deferred/gMc")
local module2 = require("@luauforge/bundled/dRX")

return function()
	return function(object)
		object:dispatch(module2((module(object:getState()))))
	end
end
