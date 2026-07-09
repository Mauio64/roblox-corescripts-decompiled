local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script:GetFullName() .. ":EditChatGroupNameDialogScreen")

v2:setContext({
	screen = "EditChatGroupNameDialogScreen"
})

return v2
