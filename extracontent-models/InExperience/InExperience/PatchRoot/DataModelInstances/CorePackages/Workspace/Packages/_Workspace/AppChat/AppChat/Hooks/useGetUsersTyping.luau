local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local selectUsersTyping = require(AppChat.Components.ChatConversation.Conversations.Selectors.selectUsersTyping)

return function(p: string)
	return useSelector(function(p2)
		return selectUsersTyping(p2, p)
	end)
end
