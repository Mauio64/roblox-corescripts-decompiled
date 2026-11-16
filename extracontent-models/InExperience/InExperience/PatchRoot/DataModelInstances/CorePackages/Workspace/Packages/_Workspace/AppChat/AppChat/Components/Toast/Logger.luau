local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new("RoactChat.Toast")
v:setContext({ screen = "Toast" })

return v
