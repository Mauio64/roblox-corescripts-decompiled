local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local selectConversations = require(AppChat.Components.ChatLanding.Conversations.Selectors.selectConversations)

return function() -- line: 7
	-- upvalues: useSelector (copy), selectConversations (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: selectConversations (copy)
		return selectConversations(p1)
	end)
end
