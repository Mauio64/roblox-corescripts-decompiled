local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXSlotBasedEditorPrimaryEntryPoint2", false)

return function()
	return module() and game:GetFastFlag("AXSlotBasedEditorPrimaryEntryPoint2")
end
