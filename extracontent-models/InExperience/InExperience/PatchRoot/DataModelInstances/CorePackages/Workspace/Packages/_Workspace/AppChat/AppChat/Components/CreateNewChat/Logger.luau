local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new("RoactChat.CreateNewChat")
v:setContext({ screen = "CreateNewChat" })

return v
