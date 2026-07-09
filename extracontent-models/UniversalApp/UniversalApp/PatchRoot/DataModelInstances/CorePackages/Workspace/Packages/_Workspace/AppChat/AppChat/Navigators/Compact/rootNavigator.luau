local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local ToastScreen = require(AppChat.Components.Toast.ToastScreen)
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)
local chatLandingWithDialogsNavigator = require(script.Parent.chatLandingWithDialogsNavigator)
local v9 = Roact.Component:extend("ChatLandingWithDialogsNavigatorConnector")

v9.router = chatLandingWithDialogsNavigator.router

function v9.render(p1) -- line: 17
	-- upvalues: Roact (copy), chatLandingWithDialogsNavigator (copy)
	return Roact.createElement(chatLandingWithDialogsNavigator, p1.props)
end

return RoactNavigation.createRobloxStackNavigator({
	{
		ChatLandingWithDialogs = v9
	},
	{
		[EnumScreens.RoactChatToast] = {
			screen = ToastScreen,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = false
			}
		}
	}
}, {
	defaultNavigationOptions = if not FFlagAppChatDisableAbsorbInputSelectable then nil else {
		absorbInputSelectable = false
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
