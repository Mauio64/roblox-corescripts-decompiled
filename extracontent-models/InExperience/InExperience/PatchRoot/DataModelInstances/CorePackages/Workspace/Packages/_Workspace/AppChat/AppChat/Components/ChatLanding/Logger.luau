local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new("RoactChat.ChatLanding")
v:setContext({ screen = "ChatLanding" })

return v
