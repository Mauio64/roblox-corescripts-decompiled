local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)

local EnumScreens = require(AppChat.EnumScreens)

return function(p, conversationId: string, extraParams)
	p.navigate(EnumScreens.ChatLanding, nil, RoactNavigation.StackActions.reset({
		index = 2,
		actions = {
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = { conversationId = conversationId }
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = { conversationId = conversationId, extraParams = extraParams }
			})
		}
	}))
end
