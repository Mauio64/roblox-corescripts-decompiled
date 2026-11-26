local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXEnableInventorySortsAndFilters2", false)

return function()
	return module() and game:GetFastFlag("AXEnableInventorySortsAndFilters2")
end
