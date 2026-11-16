local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local function createPagesNavigator(p, p2)
	local switchRouter = RoactNavigation.SwitchRouter(p2, {})
	return RoactNavigation.createNavigator(p, switchRouter, {})
end

return createPagesNavigator
