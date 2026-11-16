local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local Constants = require(InExperienceSideSheet.Common.Constants)

return function(p: number, p2: number, p3: number)
	return p - p2 - Constants.MenuScreenMargin * 2 - p3
end
