local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/fps")

return function(object, p2, p3, p4, p5, p6)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "kwd")
	module.isType(p5, "string", "page")

	local v5 = p4 == true and 1 or 0

	local v6 = not p6 and "" or module2.convertSuggestionsToString(p6)

	object:sendEventDeferred(p2, "catalogSearch", {
		locale = LocalizationService.RobloxLocaleId,
		kwd = p3,
		autoCompleteFlag = v5,
		previousPage = p5,
		suggestions = v6
	})
end
