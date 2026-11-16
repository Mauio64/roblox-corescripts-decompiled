local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/fps")

return function(object, p2, p3, p4, list, p5, p6)
	module.isType(p2, "string", "eventContext")
	module.isType(p3, "string", "kwd")
	module.isType(p4, "string", "searchType")
	module.isType(list, "table", "entries")
	module.isType(p5, "number", "clickedPos")
	module.isType(p6, "table", "clickedEntry")

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local suggestionNameTypeStrings = module2.getSuggestionNameTypeStrings(p6)
	object:setRBXEventStream(p2, "searchSuggestionClicked", {
		locale = robloxLocaleId,
		kwd = p3,
		searchType = p4,
		suggestions = module2.convertSuggestionsToString(list),
		suggestionPosition = p5,
		suggestionClicked = suggestionNameTypeStrings.name,
		suggestionType = suggestionNameTypeStrings.type,
		maxResults = #list
	})
end
