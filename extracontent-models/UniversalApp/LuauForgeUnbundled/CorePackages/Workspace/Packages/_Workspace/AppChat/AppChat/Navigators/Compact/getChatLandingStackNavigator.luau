local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local chatLandingStackNavigatorScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Compact/chatLandingStackNavigatorScreens")

local FFlagAppChatDisableAbsorbInputSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDisableAbsorbInputSelectable")

local function instantTransitionConfig()
	return {
		transitionSpec = { frequency = 1000000, dampingRatio = 1 }
	}
end

local function getChatLandingStackNavigator(p2)
	return RoactNavigation.createRobloxStackNavigator(chatLandingStackNavigatorScreens, {
		defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and { absorbInputSelectable = false } or nil,
		transitionConfig = if p2 then instantTransitionConfig else nil
	})
end

return getChatLandingStackNavigator
