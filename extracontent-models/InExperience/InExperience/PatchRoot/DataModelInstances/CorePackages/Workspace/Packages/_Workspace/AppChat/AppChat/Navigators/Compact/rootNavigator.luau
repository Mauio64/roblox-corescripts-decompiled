local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)

local EnumScreens = require(AppChat.EnumScreens)
local ToastScreen = require(AppChat.Components.Toast.ToastScreen)

local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)

local chatLandingWithDialogsNavigator = require(script.Parent.chatLandingWithDialogsNavigator)

local extended = Roact.Component:extend("ChatLandingWithDialogsNavigatorConnector")
extended.router = chatLandingWithDialogsNavigator.router

function extended.render(p)
	return Roact.createElement(chatLandingWithDialogsNavigator, p.props)
end

return RoactNavigation.createRobloxStackNavigator({
	{ ChatLandingWithDialogs = extended },
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
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and {
		absorbInputSelectable = false
	} or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
