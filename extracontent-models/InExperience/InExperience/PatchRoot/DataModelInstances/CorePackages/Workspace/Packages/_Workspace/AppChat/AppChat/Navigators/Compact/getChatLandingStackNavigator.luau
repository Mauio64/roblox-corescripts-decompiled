local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)
local chatLandingStackNavigatorScreens = require(script.Parent.chatLandingStackNavigatorScreens)

local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)

local function instantTransitionConfig()
	return {
		transitionSpec = { frequency = 1000000, dampingRatio = 1 }
	}
end

local function getChatLandingStackNavigator(p)
	local createRobloxStackNavigator = RoactNavigation.createRobloxStackNavigator
	local v = {
		defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and {
			absorbInputSelectable = false
		} or nil,
		transitionConfig = 0
	}
	local transitionConfig

	if p then
		transitionConfig = instantTransitionConfig
	end

	v.transitionConfig = transitionConfig
	return createRobloxStackNavigator(chatLandingStackNavigatorScreens, v)
end

return getChatLandingStackNavigator
