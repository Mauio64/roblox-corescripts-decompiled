local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return function(p1, p2, p3, p4) -- line: 7
	-- upvalues: ArgCheck (copy), LocalizationService (copy)
	ArgCheck.isType(p3, "string", "playSource")
	ArgCheck.isType(p4, "string", "response")
	p1:setRBXEventStream(p2, "playButtonClicked", {
		locale = LocalizationService.RobloxLocaleId,
		playSource = p3,
		response = p4
	})
end
