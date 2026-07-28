local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local Responsive = require(Parent.Responsive)

local function shouldShowScrollArrowsForInputType(s1: string) -- line: 9
	-- upvalues: Responsive (copy)
	return s1 ~= Responsive.Input.Touch
end

return shouldShowScrollArrowsForInputType
