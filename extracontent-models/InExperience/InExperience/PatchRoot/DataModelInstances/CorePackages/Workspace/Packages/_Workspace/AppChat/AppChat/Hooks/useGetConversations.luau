local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local selectConversations = require(AppChat.Components.ChatLanding.Conversations.Selectors.selectConversations)

return function()
	return useSelector(function(p)
		return selectConversations(p)
	end)
end
