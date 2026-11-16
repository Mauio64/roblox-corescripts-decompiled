local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local Constants = require(InExperienceSideSheet.Common.Constants)

return function(p: number, p2: number)
	return p - Constants.MenuScreenMargin * 2 - p2
end
