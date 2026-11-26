local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXEnableNewInventoryItemsList2", false)

return function()
	return module() and game:GetFastFlag("AXEnableNewInventoryItemsList2")
end
