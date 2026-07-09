local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("AXEnableAutomaticSizeGradientFrame2", false)

return function() -- line: 4
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy)
	return GetFFlagAXEnableSlotBasedEditor() and game:GetFastFlag("AXEnableAutomaticSizeGradientFrame2")
end
