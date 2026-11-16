local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new("RoactChat.ChatConversation")
v:setContext({ screen = "ChatConversation" })

return v
