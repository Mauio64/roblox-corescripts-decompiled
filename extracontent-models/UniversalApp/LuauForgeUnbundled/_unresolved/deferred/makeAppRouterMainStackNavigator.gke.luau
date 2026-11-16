local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local module = require("@luauforge/deferred/gkf")

local module2 = require("@luauforge/deferred/gkh")

local function makeAppRouterMainStackNavigator(p2)
	return (module(module2(p2), {
		mode = RoactNavigation.StackPresentationStyle.Overlay,
		defaultNavigationOptions = {
			overlayEnabled = true,
			overlayTransparency = 1,
			absorbInput = false,
			renderUnderlyingPage = true
		}
	}))
end

return makeAppRouterMainStackNavigator
