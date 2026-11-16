local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new("RoactChat.EditChatMembers")
v:setContext({ screen = "EditChatMembers" })

return v
