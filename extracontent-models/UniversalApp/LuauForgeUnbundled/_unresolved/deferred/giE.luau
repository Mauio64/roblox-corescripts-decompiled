local module = require("@luauforge/bundled/dOc")
game:DefineFastFlag("AXEnableClearAllConfirmationPrompt2", false)

return module() and game:GetFastFlag("AXEnableClearAllConfirmationPrompt2")
