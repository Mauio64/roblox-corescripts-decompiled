local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)

local EnumScreens = require(AppChat.EnumScreens)

return function(p, conversationId: string, extraParams)
	p.reset(
		{
			RoactNavigation.Actions.navigate({ routeName = EnumScreens.ChatLanding }),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = { conversationId = conversationId }
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = { conversationId = conversationId, extraParams = extraParams }
			})
		},
		3
	)
end
