local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new("RoactChat.ChatLanding")

v2:setContext({
	screen = "ChatLanding"
})

return v2
