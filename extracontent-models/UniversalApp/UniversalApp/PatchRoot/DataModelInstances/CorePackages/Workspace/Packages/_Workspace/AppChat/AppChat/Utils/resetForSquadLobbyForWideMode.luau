local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)

return function(p1, s1: string, p2) -- line: 9
	-- upvalues: EnumScreens (copy), RoactNavigation (copy)
	p1.navigate(EnumScreens.ChatLanding, nil, RoactNavigation.StackActions.reset({
		index = 2,
		actions = {
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = {
					conversationId = s1
				}
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = {
					conversationId = s1,
					extraParams = p2
				}
			})
		}
	}))
end
