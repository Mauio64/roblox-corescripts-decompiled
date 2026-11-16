local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new(script:GetFullName() .. ":EditChatGroupNameDialogScreen")
v:setContext({ screen = "EditChatGroupNameDialogScreen" })

return v
