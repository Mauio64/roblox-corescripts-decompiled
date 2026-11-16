local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new(script:GetFullName() .. ":LeaveGroupDialogScreen")
v:setContext({ screen = "LeaveGroupDialogScreen" })

return v
