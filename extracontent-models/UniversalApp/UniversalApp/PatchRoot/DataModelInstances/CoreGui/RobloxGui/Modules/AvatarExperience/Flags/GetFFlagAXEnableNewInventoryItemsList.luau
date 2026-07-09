local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("AXEnableNewInventoryItemsList2", false)

return function() -- line: 4
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy)
	return GetFFlagAXEnableSlotBasedEditor() and game:GetFastFlag("AXEnableNewInventoryItemsList2")
end
