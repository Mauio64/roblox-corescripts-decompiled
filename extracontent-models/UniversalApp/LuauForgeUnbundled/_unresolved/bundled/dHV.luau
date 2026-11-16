local module = require("@luauforge/bundled/dHR")

require("@luauforge/bundled/dHT")

return module.makeActionCreator("SetLastSelectedHeadShape", function(p2)
	return { headShape = p2 }
end)
