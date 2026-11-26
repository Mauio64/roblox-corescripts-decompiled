local module = require("@luauforge/bundled/dLa")

require("@luauforge/bundled/dLc")

return module.makeActionCreator("SetAvailableHeadShapes", function(p2)
	return { headShapes = p2 }
end)
