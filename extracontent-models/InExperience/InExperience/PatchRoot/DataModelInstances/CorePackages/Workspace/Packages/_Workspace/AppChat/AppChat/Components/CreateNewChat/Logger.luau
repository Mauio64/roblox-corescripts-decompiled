local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new("RoactChat.CreateNewChat")

v2:setContext({
	screen = "CreateNewChat"
})

return v2
