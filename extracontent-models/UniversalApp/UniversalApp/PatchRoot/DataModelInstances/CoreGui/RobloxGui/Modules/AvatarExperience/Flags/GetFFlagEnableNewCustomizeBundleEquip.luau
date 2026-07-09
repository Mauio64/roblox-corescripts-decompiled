local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("EnableNewCustomizeBundleEquip3", false)

return function() -- line: 5
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy)
	return game:GetFastFlag("EnableNewCustomizeBundleEquip3") and GetFFlagAXEnableSlotBasedEditor()
end
