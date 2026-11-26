local module = require("@luauforge/bundled/ibP")

local module2 = require("@luauforge/bundled/ibQ")

return module.createComputed(function(p2)
	return module2()
end)
