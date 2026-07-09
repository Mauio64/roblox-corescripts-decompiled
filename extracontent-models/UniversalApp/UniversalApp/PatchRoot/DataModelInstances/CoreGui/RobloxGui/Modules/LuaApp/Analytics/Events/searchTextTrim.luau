local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2, p3, p4, p5) -- line: 7
	-- upvalues: ArgCheck (copy), LocalizationService (copy)
	ArgCheck.isType(p2, "string", "eventContext")
	ArgCheck.isType(p3, "string", "kwd")
	ArgCheck.isType(p4, "string", "resultingKwd")
	ArgCheck.isType(p5, "string", "searchType")
	p1:setRBXEventStream(p2, "searchTextTrim", {
		locale = LocalizationService.RobloxLocaleId,
		kwd = p3,
		resultingKwd = p4,
		searchType = p5
	})
end
