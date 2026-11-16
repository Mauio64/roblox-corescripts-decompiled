local module = require("@luauforge/bundled/dHR")

require("@luauforge/bundled/dHT")

return module.makeActionCreator("SetAvailableHeadShapes", function(p2)
	return { headShapes = p2 }
end)
