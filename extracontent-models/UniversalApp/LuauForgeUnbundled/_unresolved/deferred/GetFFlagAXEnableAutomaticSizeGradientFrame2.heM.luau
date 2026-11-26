local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXEnableAutomaticSizeGradientFrame2", false)

return function()
	return module() and game:GetFastFlag("AXEnableAutomaticSizeGradientFrame2")
end
