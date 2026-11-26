local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXExtractEmotesCategory2", false)

return function()
	return module() and game:GetFastFlag("AXExtractEmotesCategory2")
end
