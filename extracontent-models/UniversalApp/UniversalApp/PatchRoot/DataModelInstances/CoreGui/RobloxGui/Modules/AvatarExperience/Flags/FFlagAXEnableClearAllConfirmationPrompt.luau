local GetFFlagAXEnableSlotBasedEditor = require(script.Parent.GetFFlagAXEnableSlotBasedEditor)

game:DefineFastFlag("AXEnableClearAllConfirmationPrompt2", false)

return GetFFlagAXEnableSlotBasedEditor() and game:GetFastFlag("AXEnableClearAllConfirmationPrompt2")
