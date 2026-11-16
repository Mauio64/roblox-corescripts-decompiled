local module = require("@luauforge/bundled/dOc")
game:DefineFastFlag("AXTransitionMenuV2_2", false)

return function()
	return module() and game:GetFastFlag("AXTransitionMenuV2_2")
end
