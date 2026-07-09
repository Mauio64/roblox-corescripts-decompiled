local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("AXSlotBasedEditorPrimaryEntryPoint2", false)

return function() -- line: 4
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy)
	return GetFFlagAXEnableSlotBasedEditor() and game:GetFastFlag("AXSlotBasedEditorPrimaryEntryPoint2")
end
