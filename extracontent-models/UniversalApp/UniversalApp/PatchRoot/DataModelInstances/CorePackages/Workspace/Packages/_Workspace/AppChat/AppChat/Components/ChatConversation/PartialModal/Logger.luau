local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script:GetFullName() .. ":ChatConversationPartialModal")

v2:setContext({
	screen = "ChatConversationPartialModal"
})

return v2
