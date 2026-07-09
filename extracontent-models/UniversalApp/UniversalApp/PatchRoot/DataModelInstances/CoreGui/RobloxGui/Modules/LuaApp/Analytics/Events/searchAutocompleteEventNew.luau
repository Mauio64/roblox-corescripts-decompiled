local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SearchEventUtil = require(Modules.LuaApp.Analytics.Events.SearchEventUtil)
local GetFIntLuaAppAutocompleteDebounceMs = require(Modules.LuaApp.Flags.GetFIntLuaAppAutocompleteDebounceMs)

return function(p1, p2, p3, p4, p5, p6, p7, p8, p9) -- line: 32
	-- upvalues: ArgCheck (copy), LocalizationService (copy), SearchEventUtil (copy), GetFIntLuaAppAutocompleteDebounceMs (copy)
	if p3 == p4 then
		return
	end

	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "kwd")
	ArgCheck.isType(p4, "string", "prevKwd")
	ArgCheck.isType(p5, "table", "suggestion")
	ArgCheck.isType(p6, "string", "page")

	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	p1:sendEventDeferred(p2, "searchAutocomplete", {
		searchBox = "mobile",
		locale = RobloxLocaleId,
		suggestions = SearchEventUtil.convertSuggestionsToString(p5.entries),
		kwd = p3,
		prevKwd = p4,
		page = p6,
		latency = p7,
		fromLocalCache = p8,
		algorithm = p5.algorithmName,
		timeoutDelayMs = GetFIntLuaAppAutocompleteDebounceMs(),
		maxResults = #p5.entries,
		searchType = p9
	})
end
