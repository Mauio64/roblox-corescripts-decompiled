local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SearchEventUtil = require(Modules.LuaApp.Analytics.Events.SearchEventUtil)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 9
	-- upvalues: ArgCheck (copy), LocalizationService (copy), SearchEventUtil (copy)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "kwd")
	ArgCheck.isType(p4, "string", "searchType")
	ArgCheck.isType(p5, "table", "entries")
	ArgCheck.isType(p6, "number", "clickedPos")
	ArgCheck.isType(p7, "table", "clickedEntry")

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v14 = SearchEventUtil.getSuggestionNameTypeStrings(p7)

	p1:setRBXEventStream(p2, "searchSuggestionClicked", {
		locale = RobloxLocaleId,
		kwd = p3,
		searchType = p4,
		suggestions = SearchEventUtil.convertSuggestionsToString(p5),
		suggestionPosition = p6,
		suggestionClicked = v14.name,
		suggestionType = v14.type,
		maxResults = #p5
	})
end
