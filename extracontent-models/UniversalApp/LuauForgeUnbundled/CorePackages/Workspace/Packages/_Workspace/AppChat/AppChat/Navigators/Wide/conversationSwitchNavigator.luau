local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local EmptyConversationScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EmptyConversationScreen")

local ConversationStackNavigatorConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/ConversationStackNavigatorConnector")

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
