local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Responsive")

local function shouldShowScrollArrowsForInputType(p2): boolean
	return p2 ~= Responsive.Input.Touch
end

return shouldShowScrollArrowsForInputType
