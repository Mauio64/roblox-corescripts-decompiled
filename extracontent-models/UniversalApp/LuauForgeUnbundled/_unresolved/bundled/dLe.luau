local module = require("@luauforge/bundled/dLa")

require("@luauforge/bundled/dLc")

return module.makeActionCreator("SetLastSelectedHeadShape", function(p2)
	return { headShape = p2 }
end)
