local module = require("@luauforge/bundled/hSq")

local module2 = require("@luauforge/bundled/hSr")

return module.createComputed(function(p2)
	return module2()
end)
