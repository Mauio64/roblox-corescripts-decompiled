local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXEnableBatchUnequips2", false)

return function()
	return module() and game:GetFastFlag("AXEnableBatchUnequips2")
end
