local module = require("@luauforge/bundled/dOc")
game:DefineFastFlag("AXEnableAutomaticSizeGradientFrame2", false)

return function()
	return module() and game:GetFastFlag("AXEnableAutomaticSizeGradientFrame2")
end
