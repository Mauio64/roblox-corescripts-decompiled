local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")

return function(p2, p3)
	return function(object)
		object:dispatch(module2(module.ExperienceGuidelinesExplained, {
			universeId = p2,
			hideCloseButton = p3
		}))
	end
end
