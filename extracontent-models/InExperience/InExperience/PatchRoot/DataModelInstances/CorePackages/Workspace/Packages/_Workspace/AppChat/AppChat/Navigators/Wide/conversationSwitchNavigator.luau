local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)

local EnumScreens = require(AppChat.EnumScreens)
local EmptyConversationScreen = require(AppChat.Components.ChatConversation.EmptyConversationScreen)

local ConversationStackNavigatorConnector = require(script.Parent.ConversationStackNavigatorConnector)

return (RoactNavigation.createRobloxSwitchNavigator({
	{
		[EnumScreens.EmptyConversation] = {
			screen = EmptyConversationScreen,
			navigationOptions = {
				headerText = { raw = "testing", shouldLocalize = false },
				backButtonEnabled = false,
				isRoot = true,
				tabBarVisible = true
			}
		}
	},
	{ ConversationStackNavigator = ConversationStackNavigatorConnector }
}))
