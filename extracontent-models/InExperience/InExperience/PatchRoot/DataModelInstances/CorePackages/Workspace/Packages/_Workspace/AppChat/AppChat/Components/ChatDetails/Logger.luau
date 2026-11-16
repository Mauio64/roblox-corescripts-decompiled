local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new("RoactChat.ChatDetails")
v:setContext({ screen = "ChatDetails" })

return v
