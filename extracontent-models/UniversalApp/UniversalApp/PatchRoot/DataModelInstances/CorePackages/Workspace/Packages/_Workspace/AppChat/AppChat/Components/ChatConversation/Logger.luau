local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new("RoactChat.ChatConversation")

v2:setContext({
	screen = "ChatConversation"
})

return v2
