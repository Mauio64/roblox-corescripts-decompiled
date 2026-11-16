local ExpChat = script:FindFirstAncestor("ExpChat")

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

return function(p)
	GetMessagesStore(false).handleLegacyBubbleCreated(p)
end
