local Parent = script:FindFirstAncestor("MultiPageSignup").Parent
local RoactNavigation = require(Parent.RoactNavigation)

require(Parent.Navigation)
require(Parent.UserActivationFramework)

local function createMultiPageSignupNavigator(p1, p2, b1: boolean) -- line: 10
	-- upvalues: RoactNavigation (copy)
	if b1 then
		return RoactNavigation.createRobloxStackNavigator(p1, {
			keepVisitedScreensMounted = true,
			renderUnderlyingPage = true,
			initialRouteName = p2,
			defaultNavigationOptions = {
				overlayTransparency = 1
			},
			mode = RoactNavigation.StackPresentationStyle.Default,
			backBehavior = RoactNavigation.BackBehavior.History
		})
	end

	return RoactNavigation.createRobloxSwitchNavigator(p1, {
		keepVisitedScreensMounted = true,
		initialRouteName = p2,
		backBehavior = RoactNavigation.BackBehavior.History
	})
end

return createMultiPageSignupNavigator
