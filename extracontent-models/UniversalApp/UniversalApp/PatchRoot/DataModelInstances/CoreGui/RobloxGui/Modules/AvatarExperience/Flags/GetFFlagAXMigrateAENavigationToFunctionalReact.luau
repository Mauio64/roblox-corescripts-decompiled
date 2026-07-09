local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("AXMigrateAENavigationToFunctionalReact2", false)

return function() -- line: 4
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy)
	return GetFFlagAXEnableSlotBasedEditor() and game:GetFastFlag("AXMigrateAENavigationToFunctionalReact2")
end
