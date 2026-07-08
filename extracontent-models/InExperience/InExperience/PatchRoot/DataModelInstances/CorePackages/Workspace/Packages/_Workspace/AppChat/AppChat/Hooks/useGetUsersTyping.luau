local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local selectUsersTyping = require(AppChat.Components.ChatConversation.Conversations.Selectors.selectUsersTyping)

return function(s1: string) -- line: 7
	-- upvalues: useSelector (copy), selectUsersTyping (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: selectUsersTyping (copy), s1 (copy)
		return selectUsersTyping(p1, s1)
	end)
end
