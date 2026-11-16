local module = require("@luauforge/bundled/dOc")
game:DefineFastFlag("AXEnableInventorySortsAndFilters2", false)

return function()
	return module() and game:GetFastFlag("AXEnableInventorySortsAndFilters2")
end
