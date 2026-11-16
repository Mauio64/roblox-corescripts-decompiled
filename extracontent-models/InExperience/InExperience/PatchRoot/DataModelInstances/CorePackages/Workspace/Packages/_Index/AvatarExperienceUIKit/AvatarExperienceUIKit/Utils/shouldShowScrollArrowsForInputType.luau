local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local Responsive = require(parent.Responsive)

local function shouldShowScrollArrowsForInputType(p: string): boolean
	return p ~= Responsive.Input.Touch
end

return shouldShowScrollArrowsForInputType
