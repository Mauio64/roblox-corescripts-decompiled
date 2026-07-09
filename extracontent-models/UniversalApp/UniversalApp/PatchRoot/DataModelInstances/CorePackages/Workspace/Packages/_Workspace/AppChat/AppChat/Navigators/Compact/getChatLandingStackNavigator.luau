local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local chatLandingStackNavigatorScreens = require(script.Parent.chatLandingStackNavigatorScreens)
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)

local function instantTransitionConfig() -- line: 10
	return {
		transitionSpec = {
			frequency = 1000000,
			dampingRatio = 1
		}
	}
end
local function getChatLandingStackNavigator(p1) -- line: 19
	-- upvalues: RoactNavigation (copy), chatLandingStackNavigatorScreens (copy), FFlagAppChatDisableAbsorbInputSelectable (copy), instantTransitionConfig (copy)
	return RoactNavigation.createRobloxStackNavigator(chatLandingStackNavigatorScreens, {
		defaultNavigationOptions = if not FFlagAppChatDisableAbsorbInputSelectable then nil else {
			absorbInputSelectable = false
		},
		transitionConfig = if not p1 then nil else instantTransitionConfig
	})
end

return getChatLandingStackNavigator
