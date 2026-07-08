local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new("RoactChat.ChatDetails")

v2:setContext({
	screen = "ChatDetails"
})

return v2
