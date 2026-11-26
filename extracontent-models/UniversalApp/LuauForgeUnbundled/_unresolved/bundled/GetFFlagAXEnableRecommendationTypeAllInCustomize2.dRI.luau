local module = require("@luauforge/bundled/dRs")
game:DefineFastFlag("AXEnableRecommendationTypeAllInCustomize2", false)

return function()
	return module() and game:GetFastFlag("AXEnableRecommendationTypeAllInCustomize2")
end
