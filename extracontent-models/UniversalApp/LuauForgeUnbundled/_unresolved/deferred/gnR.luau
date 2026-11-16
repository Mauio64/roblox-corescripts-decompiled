local module = require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dHK")

local setEquippedInTryOnManager = module.Actions.SetEquippedInTryOnManager

return function(p2, p3, p4, p5, p6)
	return function(object)
		object:dispatch(setEquippedInTryOnManager(p2, p3, p5))
	end
end
