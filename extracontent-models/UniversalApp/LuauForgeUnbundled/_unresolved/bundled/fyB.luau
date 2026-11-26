local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/fwN")

local module3 = require("@luauforge/bundled/fyA")

return function(object, p2, p3, p4, p5, p6, p7, p8, p9)
	if p3 == p4 then
		return
	end

	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "kwd")
	module.isType(p4, "string", "prevKwd")
	module.isType(p5, "table", "suggestion")
	module.isType(p6, "string", "page")

	object:sendEventDeferred(p2, "searchAutocomplete", {
		locale = LocalizationService.RobloxLocaleId,
		suggestions = module2.convertSuggestionsToString(p5.entries),
		kwd = p3,
		prevKwd = p4,
		page = p6,
		latency = p7,
		fromLocalCache = p8,
		algorithm = p5.algorithmName,
		timeoutDelayMs = module3(),
		maxResults = #p5.entries,
		searchType = p9,
		searchBox = "mobile"
	})
end
