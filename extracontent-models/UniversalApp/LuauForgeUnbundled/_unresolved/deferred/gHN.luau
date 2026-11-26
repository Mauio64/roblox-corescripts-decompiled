local module = require("@luauforge/deferred/gHO")
local module2 = require("@luauforge/deferred/gHR")

return function(p2, p3, p4, value, value2)
	return module2((module:new(p2, p3, nil, p4 or false, value or 0, value2 or 0)))
end
