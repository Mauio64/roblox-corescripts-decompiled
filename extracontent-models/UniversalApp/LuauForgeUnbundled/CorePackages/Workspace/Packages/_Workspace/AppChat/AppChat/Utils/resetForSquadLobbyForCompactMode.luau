local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

return function(p2, p3, p4)
	p2.reset({
		RoactNavigation.Actions.navigate({ routeName = EnumScreens.ChatLanding }),
		RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatConversation,
			params = { conversationId = p3 }
		}),
		RoactNavigation.Actions.navigate({
			routeName = EnumScreens.SquadLobby,
			params = { conversationId = p3, extraParams = p4 }
		})
	}, 3)
end
