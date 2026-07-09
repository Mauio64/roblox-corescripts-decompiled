local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local ToastScreen = require(AppChat.Components.Toast.ToastScreen)
local chatLandingWithDialogsNavigator = require(script.Parent.chatLandingWithDialogsNavigator)
local v8 = Roact.Component:extend("ChatLandingWithDialogsNavigatorConnector")

v8.router = chatLandingWithDialogsNavigator.router

function v8.render(p1) -- line: 15
	-- upvalues: Roact (copy), chatLandingWithDialogsNavigator (copy)
	return Roact.createElement(chatLandingWithDialogsNavigator, p1.props)
end

return RoactNavigation.createRobloxStackNavigator({
	{
		ChatLandingWithDialogs = v8
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
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
