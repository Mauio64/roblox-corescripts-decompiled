local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dzP")

return function(object, p2, p3, p4)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "kwd")
	module.isType(p4, "string", "searchType")

	object:setRBXEventStream(p2, "searchClear", {
		locale = LocalizationService.RobloxLocaleId,
		kwd = p3,
		searchType = p4
	})
end
