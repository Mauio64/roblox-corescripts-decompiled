local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new(script:GetFullName() .. ":MessageInteraction")
v:setContext({ screen = "MessageContextMenuScreen" })

return v
