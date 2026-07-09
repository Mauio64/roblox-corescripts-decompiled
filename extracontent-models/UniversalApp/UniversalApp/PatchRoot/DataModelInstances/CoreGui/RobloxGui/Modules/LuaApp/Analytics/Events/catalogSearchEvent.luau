local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchEventUtil = require(Modules.LuaApp.Analytics.Events.SearchEventUtil)

return function(p1, p2, p3, p4, p5, p6) -- line: 18
	-- upvalues: ArgCheck (copy), SearchEventUtil (copy), LocalizationService (copy)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "kwd")
	ArgCheck.isType(p5, "string", "page")

	local n1 = 0

	if p4 == true then
		n1 = 1
	end

	local s1 = ""

	if p6 then
		s1 = SearchEventUtil.convertSuggestionsToString(p6)
	end

	p1:sendEventDeferred(p2, "catalogSearch", {
		locale = LocalizationService.RobloxLocaleId,
		kwd = p3,
		autoCompleteFlag = n1,
		previousPage = p5,
		suggestions = s1
	})
end
