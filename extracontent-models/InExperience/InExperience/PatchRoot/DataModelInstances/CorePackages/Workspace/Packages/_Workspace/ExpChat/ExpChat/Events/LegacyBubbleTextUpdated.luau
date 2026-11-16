local ExpChat = script:FindFirstAncestor("ExpChat")

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

return function(p: string, p2: string)
	GetMessagesStore(false).handleLegacyBubbleTextUpdated(p, p2)
end
