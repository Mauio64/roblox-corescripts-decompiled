local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new(script:GetFullName() .. ":ChatConversationPartialModal")
v:setContext({ screen = "ChatConversationPartialModal" })

return v
