local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new("RoactChat.Toast")

v2:setContext({
	screen = "Toast"
})

return v2
