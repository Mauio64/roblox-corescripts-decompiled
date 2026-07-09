local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("AXEnableInventorySortsAndFilters2", false)

return function() -- line: 4
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy)
	return GetFFlagAXEnableSlotBasedEditor() and game:GetFastFlag("AXEnableInventorySortsAndFilters2")
end
