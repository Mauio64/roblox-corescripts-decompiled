local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new("RoactChat.EditChatMembers")

v2:setContext({
	screen = "EditChatMembers"
})

return v2
