local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local EmptyConversationScreen = require(AppChat.Components.ChatConversation.EmptyConversationScreen)
local ConversationStackNavigatorConnector = require(script.Parent.ConversationStackNavigatorConnector)

return (RoactNavigation.createRobloxSwitchNavigator({
	{
		[EnumScreens.EmptyConversation] = {
			screen = EmptyConversationScreen,
			navigationOptions = {
				backButtonEnabled = false,
				isRoot = true,
				tabBarVisible = true,
				headerText = {
					raw = "testing",
					shouldLocalize = false
				}
			}
		}
	},
	{
		ConversationStackNavigator = ConversationStackNavigatorConnector
	}
}))
