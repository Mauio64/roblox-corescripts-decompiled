local module = require("@luauforge/bundled/dOc")
game:DefineFastFlag("AXSlotBasedEditorPrimaryEntryPoint2", false)

return function()
	return module() and game:GetFastFlag("AXSlotBasedEditorPrimaryEntryPoint2")
end
