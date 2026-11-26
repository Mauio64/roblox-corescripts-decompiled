local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dzP")

return function(object, p2, p3, p4, p5)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "kwd")
	module.isType(p4, "string", "resultingKwd")
	module.isType(p5, "string", "searchType")

	object:setRBXEventStream(p2, "searchTextTrim", {
		locale = LocalizationService.RobloxLocaleId,
		kwd = p3,
		resultingKwd = p4,
		searchType = p5
	})
end
