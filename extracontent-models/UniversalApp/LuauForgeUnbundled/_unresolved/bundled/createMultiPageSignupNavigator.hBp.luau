local module = require("@luauforge/bundled/hBq")
require("@luauforge/bundled/hBr")

require("@luauforge/bundled/hBs")

local function createMultiPageSignupNavigator(p2, p3, p4)
	if p4 then
		return module.createRobloxStackNavigator(p2, {
			initialRouteName = p3,
			keepVisitedScreensMounted = true,
			renderUnderlyingPage = true,
			defaultNavigationOptions = { overlayTransparency = 1 },
			mode = module.StackPresentationStyle.Default,
			backBehavior = module.BackBehavior.History
		})
	end

	return module.createRobloxSwitchNavigator(p2, {
		initialRouteName = p3,
		keepVisitedScreensMounted = true,
		backBehavior = module.BackBehavior.History
	})
end

return createMultiPageSignupNavigator
