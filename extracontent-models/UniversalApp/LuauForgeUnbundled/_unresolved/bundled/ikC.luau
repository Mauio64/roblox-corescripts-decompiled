local module = require("@luauforge/bundled/ehl")
local module2 = require("@luauforge/bundled/ehm")

return function(p2, p3, p4, p5, p6, p7)
	return function(object)
		object:dispatch(module2(module.SurveyPrompt, {
			continueFunc = p2,
			closeFunc = p3,
			titleText = p4,
			bodyText = p5,
			cancelButtonText = p6,
			confirmButtonText = p7
		}))
	end
end
