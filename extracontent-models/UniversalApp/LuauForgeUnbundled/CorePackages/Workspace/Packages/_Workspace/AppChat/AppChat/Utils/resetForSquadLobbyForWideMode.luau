local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

return function(p2, p3, p4)
	p2.navigate(EnumScreens.ChatLanding, nil, RoactNavigation.StackActions.reset({
		index = 2,
		actions = {
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = { conversationId = p3 }
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = { conversationId = p3, extraParams = p4 }
			})
		}
	}))
end
