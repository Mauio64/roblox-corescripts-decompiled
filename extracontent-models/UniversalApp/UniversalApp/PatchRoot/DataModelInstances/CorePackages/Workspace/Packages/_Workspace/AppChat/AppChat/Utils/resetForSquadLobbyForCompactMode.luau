local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)

return function(p1, s1: string, p2) -- line: 9
	-- upvalues: RoactNavigation (copy), EnumScreens (copy)
	p1.reset({
		RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLanding
		}),
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
	}, 3)
end
