local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local function createPagesNavigator(p, p2, p3)
	local switchRouter = RoactNavigation.SwitchRouter
	local initialRouteName

	if p3 then
		initialRouteName = p3.initialRouteName
	end

	local v = switchRouter(p2, { initialRouteName = initialRouteName })

	return RoactNavigation.createNavigator(p, v, {})
end

return createPagesNavigator
