local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new(script:GetFullName() .. ":RemoveUserDialogScreen")
v:setContext({ screen = "RemoveUserDialogScreen" })

return v
